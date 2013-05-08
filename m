Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48342 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab3EHMn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 08:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <5750435.WVYuIYMX2V@avalon>
References: <1367563919-2880-1-git-send-email-prabhakar.csengg@gmail.com>
 <124364082.ILKsvVk9ro@avalon> <CA+V-a8sknnoq7M-HJUW6aW8jtf7T0qxA8OpPjsXdmxO22ic7og@mail.gmail.com>
 <5750435.WVYuIYMX2V@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 8 May 2013 18:13:03 +0530
Message-ID: <CA+V-a8sfPSEWJz1XAuGv7aPTWDjUpPTmU_Z8372tqjS8O0CCWQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3] media: i2c: mt9p031: add OF support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, May 8, 2013 at 4:07 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> On Wednesday 08 May 2013 10:19:57 Prabhakar Lad wrote:
>> On Wed, May 8, 2013 at 7:32 AM, Laurent Pinchart wrote:
>> > On Tuesday 07 May 2013 15:10:36 Prabhakar Lad wrote:
>> >> On Mon, May 6, 2013 at 8:29 PM, Prabhakar Lad wrote:
>> >> > On Fri, May 3, 2013 at 8:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >> >> On Friday 03 May 2013, Prabhakar Lad wrote:
>> >> > [snip]
>> >> >
>> >> >>> +}
>> >> >>
>> >> >> Ok, good.
>> >> >>
>> >> >>> @@ -955,7 +998,17 @@ static int mt9p031_probe(struct i2c_client
>> >> >>> *client,
>> >> >>>
>> >> >>>         mt9p031->pdata = pdata;
>> >> >>>         mt9p031->output_control = MT9P031_OUTPUT_CONTROL_DEF;
>> >> >>>         mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
>> >> >>>
>> >> >>> -       mt9p031->model = did->driver_data;
>> >> >>> +
>> >> >>> +       if (!client->dev.of_node) {
>> >> >>> +               mt9p031->model = (enum
>> >> >>> mt9p031_model)did->driver_data;
>> >> >>> +       } else {
>> >> >>> +               const struct of_device_id *of_id;
>> >> >>> +
>> >> >>> +               of_id =
>> >> >>> of_match_device(of_match_ptr(mt9p031_of_match),
>> >> >>> +                                       &client->dev);
>> >> >>> +               if (of_id)
>> >> >>> +                       mt9p031->model = (enum
>> >> >>> mt9p031_model)of_id->data;
>> >> >>> +       }
>> >> >>>
>> >> >>>         mt9p031->reset = -1;
>> >> >>
>> >> >> Is this actually required? I thought the i2c core just compared the
>> >> >> part of the "compatible" value after the first comma to the string, so
>> >> >> "mt9p031->model = (enum mt9p031_model)did->driver_data" should work
>> >> >> in both cases.
>> >> >
>> >> > I am OK with "mt9p031->model = (enum mt9p031_model)did->driver_data"
>> >> > but I see still few drivers doing this, I am not sure for what reason.
>> >> > If everyone is OK with it I can drop the above change.
>> >>
>> >> My bad, while booting with DT the i2c_device_id ie did in this case will
>> >> be NULL, so the above changes are required :-)
>> >
>> > I've just tested your patch, and did isn't NULL when booting my
>> > Beagleboard with DT (on v3.9-rc5).
>>
>> I am pretty much sure you tested it compatible property as "aptina,mt9p031"
>> if the compatible property is set to "aptina,mt9p031m" the did will be NULL.
>
> I've tested both :-)
>
Thanks for the testing :-) I'll remove this changes in the next version.

Regards,
--Prabhakar Lad
