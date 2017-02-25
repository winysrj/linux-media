Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:17836 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbdBYIBz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 03:01:55 -0500
Subject: Re: [PATCH] [media] exynos4-is: Add missing 'of_node_put'
To: Javier Martinez Canillas <javier@osg.samsung.com>,
        kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        mchehab@kernel.org, kgene@kernel.org, krzk@kernel.org
References: <20170123211656.11185-1-christophe.jaillet@wanadoo.fr>
 <2357ef6e-8d90-77d0-0399-21fec41389a1@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <c3c046ca-4f03-5023-83b9-353351a7696f@wanadoo.fr>
Date: Sat, 25 Feb 2017 09:01:19 +0100
MIME-Version: 1.0
In-Reply-To: <2357ef6e-8d90-77d0-0399-21fec41389a1@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 24/02/2017 à 22:19, Javier Martinez Canillas a écrit :
> Thanks for the patch, but Krzysztof sent the exact same patch before 
> [0]. There
> was feedback from Sylwester at the time that you can also look at [0]. Could you
> please take that into account and post a patch according to what he suggested?
>
> [0]: http://lists.infradead.org/pipermail/linux-arm-kernel/2016-March/415207.html
>
> Best regards,

Hi,

apparently, the patch has already been taken into -next by Mauro 
Carvalho Chehab.

Moreover, I personally don't think that what is proposed in [0] is more 
readable.
There is not that much code between 'of_get_next_child' and 
'of_node_put' in the normal path and not so many error handling paths 
between the 2 function calls.
Adding some indentation level is not an improvement, IMHO.

If you really want, I could propose something like the code below (not 
carefully checked, just to give an idea), but honestly, I don't think it 
is needed.
It avoids some new indent and avoids duplicating 'of_node_put'.

Tell me if you think it is an improvement and I'll send a patch.

CJ


diff --git a/drivers/media/platform/exynos4-is/media-dev.c 
b/drivers/media/platform/exynos4-is/media-dev.c
index e3a8709138fa..da5b76c1df98 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -385,38 +385,35 @@ static void fimc_md_pipelines_free(struct fimc_md 
*fmd)
  static int fimc_md_parse_port_node(struct fimc_md *fmd,
                     struct device_node *port,
                     unsigned int index)
  {
      struct fimc_source_info *pd = &fmd->sensor[index].pdata;
-    struct device_node *rem, *ep, *np;
+    struct device_node *rem = NULL, *ep = NULL, *np;
      struct v4l2_of_endpoint endpoint;
      int ret;

      /* Assume here a port node can have only one endpoint node. */
      ep = of_get_next_child(port, NULL);
      if (!ep)
          return 0;

      ret = v4l2_of_parse_endpoint(ep, &endpoint);
-    if (ret) {
-        of_node_put(ep);
-        return ret;
-    }
+    if (ret)
+        goto put_ep;

      if (WARN_ON(endpoint.base.port == 0) || index >= FIMC_MAX_SENSORS) {
-        of_node_put(ep);
-        return -EINVAL;
+        ret = -EINVAL;
+        goto put_ep;
      }

      pd->mux_id = (endpoint.base.port - 1) & 0x1;

      rem = of_graph_get_remote_port_parent(ep);
-    of_node_put(ep);
      if (rem == NULL) {
          v4l2_info(&fmd->v4l2_dev, "Remote device at %s not found\n",
                              ep->full_name);
-        return 0;
+        goto out;
      }

      if (fimc_input_is_parallel(endpoint.base.port)) {
          if (endpoint.bus_type == V4L2_MBUS_PARALLEL)
              pd->sensor_bus_type = FIMC_BUS_TYPE_ITU_601;
@@ -447,22 +444,28 @@ static int fimc_md_parse_port_node(struct fimc_md 
*fmd,
          pd->fimc_bus_type = FIMC_BUS_TYPE_ISP_WRITEBACK;
      else
          pd->fimc_bus_type = pd->sensor_bus_type;

      if (WARN_ON(index >= ARRAY_SIZE(fmd->sensor))) {
-        of_node_put(rem);
-        return -EINVAL;
+        ret = -EINVAL;
+        goto put_rem;
      }

      fmd->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_OF;
      fmd->sensor[index].asd.match.of.node = rem;
      fmd->async_subdevs[index] = &fmd->sensor[index].asd;

      fmd->num_sensors++;
+out:
+    ret = 0;

+put_rem:
      of_node_put(rem);
-    return 0;
+
+put_ep:
+    of_node_put(ep);
+    return ret;
  }

  /* Register all SoC external sub-devices */
  static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
  {
