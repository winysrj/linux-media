Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57576 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3EHKhQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 06:37:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Rob Herring <rob.herring@calxeda.com>,
	Rob Landley <rob@landley.net>,
	devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v3] media: i2c: mt9p031: add OF support
Date: Wed, 08 May 2013 12:37:29 +0200
Message-ID: <5750435.WVYuIYMX2V@avalon>
In-Reply-To: <CA+V-a8sknnoq7M-HJUW6aW8jtf7T0qxA8OpPjsXdmxO22ic7og@mail.gmail.com>
References: <1367563919-2880-1-git-send-email-prabhakar.csengg@gmail.com> <124364082.ILKsvVk9ro@avalon> <CA+V-a8sknnoq7M-HJUW6aW8jtf7T0qxA8OpPjsXdmxO22ic7og@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Wednesday 08 May 2013 10:19:57 Prabhakar Lad wrote:
> On Wed, May 8, 2013 at 7:32 AM, Laurent Pinchart wrote:
> > On Tuesday 07 May 2013 15:10:36 Prabhakar Lad wrote:
> >> On Mon, May 6, 2013 at 8:29 PM, Prabhakar Lad wrote:
> >> > On Fri, May 3, 2013 at 8:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> >> On Friday 03 May 2013, Prabhakar Lad wrote:
> >> > [snip]
> >> > 
> >> >>> +}
> >> >> 
> >> >> Ok, good.
> >> >> 
> >> >>> @@ -955,7 +998,17 @@ static int mt9p031_probe(struct i2c_client
> >> >>> *client,
> >> >>> 
> >> >>>         mt9p031->pdata = pdata;
> >> >>>         mt9p031->output_control = MT9P031_OUTPUT_CONTROL_DEF;
> >> >>>         mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
> >> >>> 
> >> >>> -       mt9p031->model = did->driver_data;
> >> >>> +
> >> >>> +       if (!client->dev.of_node) {
> >> >>> +               mt9p031->model = (enum
> >> >>> mt9p031_model)did->driver_data;
> >> >>> +       } else {
> >> >>> +               const struct of_device_id *of_id;
> >> >>> +
> >> >>> +               of_id =
> >> >>> of_match_device(of_match_ptr(mt9p031_of_match),
> >> >>> +                                       &client->dev);
> >> >>> +               if (of_id)
> >> >>> +                       mt9p031->model = (enum
> >> >>> mt9p031_model)of_id->data;
> >> >>> +       }
> >> >>> 
> >> >>>         mt9p031->reset = -1;
> >> >> 
> >> >> Is this actually required? I thought the i2c core just compared the
> >> >> part of the "compatible" value after the first comma to the string, so
> >> >> "mt9p031->model = (enum mt9p031_model)did->driver_data" should work
> >> >> in both cases.
> >> > 
> >> > I am OK with "mt9p031->model = (enum mt9p031_model)did->driver_data"
> >> > but I see still few drivers doing this, I am not sure for what reason.
> >> > If everyone is OK with it I can drop the above change.
> >> 
> >> My bad, while booting with DT the i2c_device_id ie did in this case will
> >> be NULL, so the above changes are required :-)
> > 
> > I've just tested your patch, and did isn't NULL when booting my
> > Beagleboard with DT (on v3.9-rc5).
> 
> I am pretty much sure you tested it compatible property as "aptina,mt9p031"
> if the compatible property is set to "aptina,mt9p031m" the did will be NULL.

I've tested both :-)

-- 
Regards,

Laurent Pinchart

