Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45680 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbZFVONe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 10:13:34 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Alexey Klimov <klimov.linux@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Mon, 22 Jun 2009 09:13:29 -0500
Subject: RE: [PATCH 3/11 - v3] dm355 ccdc module for vpfe capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40139EDB046@dlee06.ent.ti.com>
References: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com>
 <1245269484-8325-4-git-send-email-m-karicheri2@ti.com>
 <208cbae30906171451x789f00ak94799447c9a012a5@mail.gmail.com>
 <200906191442.17151.hverkuil@xs4all.nl>
In-Reply-To: <200906191442.17151.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> <snip>
>>
>> > +static int dm355_ccdc_init(void)
>> > +{
>> > +       printk(KERN_NOTICE "dm355_ccdc_init\n");
>> > +       if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
>> > +               return -1;
>>
>> Don't you want to rewrite this to return good error code?
>> int ret;
>> printk();
>> ret = vpfe_register_ccdc_device();
>> if (ret < 0)
>> return ret;
>>
>> I know you have tight/fast track/hard schedule, so you can do this
>> improvement later, after merging this patch.
>
>I haven't changed this or the similar comment in patch 4/11, but it is
>something that Muralidharan should look at and fix later.
>
>Regards,
>
>	Hans
[MK] I will take care of this through a separate patch

Murali
