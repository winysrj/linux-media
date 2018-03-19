Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:29800 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754511AbeCSEZB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 00:25:01 -0400
Date: Mon, 19 Mar 2018 13:24:57 +0900
From: Ji-Hun Kim <ji_hun.kim@samsung.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        arvind.yadav.cs@gmail.com, ji_hun.kim@samsung.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: Re: [PATCH] staging: media: davinci_vpfe: add error handling on
 kmalloc failure
Message-id: <20180319042457.GB2915@ubuntu>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-disposition: inline
In-reply-to: <20180316083234.yq7a4rx6w35amflu@mwanda>
References: <CGME20180316045841epcas2p34dc11231c65e2032e88ac7138db2daee@epcas2p3.samsung.com>
        <1521176303-17546-1-git-send-email-ji_hun.kim@samsung.com>
        <20180316083234.yq7a4rx6w35amflu@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 16, 2018 at 11:32:34AM +0300, Dan Carpenter wrote:
> On Fri, Mar 16, 2018 at 01:58:23PM +0900, Ji-Hun Kim wrote:
> > There is no failure checking on the param value which will be allocated
> > memory by kmalloc. Add a null pointer checking statement. Then goto error:
> > and return -ENOMEM error code when kmalloc is failed.
> > 
> > Signed-off-by: Ji-Hun Kim <ji_hun.kim@samsung.com>
> > ---
> >  drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> > index 6a3434c..55a922c 100644
> > --- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> > +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> > @@ -1280,6 +1280,10 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
> >  
> >  			params = kmalloc(sizeof(struct ipipe_module_params),
> >  					 GFP_KERNEL);
> > +			if (!params) {
> > +				rval = -ENOMEM;
> > +				goto error;
>                                 ^^^^^^^^^^
> 
> What does "goto error" do, do you think?  It's not clear from the name.
> When you have an unclear goto like this it often means the error
> handling is going to be buggy.
> 
> In this case, it does nothing so a direct "return -ENOMEM;" would be
> more clear.  But the rest of the error handling is buggy.
Hi Dan,
I appreciate for your specific feedbacks. It looks more clear. And I'd
like you to see my question below. I will send the patch v2.

> 
>   1263  static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
>   1264  {
>   1265          struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
>   1266          unsigned int i;
>   1267          int rval = 0;
>   1268  
>   1269          for (i = 0; i < ARRAY_SIZE(ipipe_modules); i++) {
>   1270                  unsigned int bit = 1 << i;
>   1271  
>   1272                  if (cfg->flag & bit) {
>   1273                          const struct ipipe_module_if *module_if =
>   1274                                                  &ipipe_modules[i];
>   1275                          struct ipipe_module_params *params;
>   1276                          void __user *from = *(void * __user *)
>   1277                                  ((void *)cfg + module_if->config_offset);
>   1278                          size_t size;
>   1279                          void *to;
>   1280  
>   1281                          params = kmalloc(sizeof(struct ipipe_module_params),
>   1282                                           GFP_KERNEL);
> 
> Do a direct return:
> 
> 				if (!params)
> 					return -ENOMEM;
> 
>   1283                          to = (void *)params + module_if->param_offset;
>   1284                          size = module_if->param_size;
>   1285  
>   1286                          if (to && from && size) {
>   1287                                  if (copy_from_user(to, from, size)) {
>   1288                                          rval = -EFAULT;
>   1289                                          break;
> 
> The most recent thing we allocated is "params" so lets do a
> "goto free_params;".  We'll have to declare "params" at the start of the
> function instead inside this block.
> 
>   1290                                  }
>   1291                                  rval = module_if->set(ipipe, to);
>   1292                                  if (rval)
>   1293                                          goto error;
> 
> goto free_params again since params is still the most recent thing we
> allocated.
> 
>   1294                          } else if (to && !from && size) {
>   1295                                  rval = module_if->set(ipipe, NULL);
>   1296                                  if (rval)
>   1297                                          goto error;
> 
> And here again goto free_params.
> 
>   1298                          }
>   1299                          kfree(params);
>   1300                  }
>   1301          }
>   1302  error:
>   1303          return rval;
> 
> 
> Change this to:
> 
> 	return 0;
Instead of returning rval, returning 0 would be fine? It looks that should
return rval in normal case.

> 
> free_params:
> 	kfree(params);
> 	return rval;
> 
>   1304  }
> 
> regards,
> dan carpenter
> 
> 
Thanks,
Ji-Hun
