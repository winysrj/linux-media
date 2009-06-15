Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44163 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbZFORlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 13:41:10 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Alexey Klimov <klimov.linux@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Mon, 15 Jun 2009 12:41:05 -0500
Subject: RE: [PATCH 1/10 - v2] vpfe capture bridge driver for DM355 and
 DM6446
Message-ID: <A69FA2915331DC488A831521EAE36FE40139DF935E@dlee06.ent.ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com>
	 <1244739649-27466-2-git-send-email-m-karicheri2@ti.com>
 <208cbae30906111541u21693b69vd67d02792f119509@mail.gmail.com>
In-Reply-To: <208cbae30906111541u21693b69vd67d02792f119509@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> +       /* set the default image parameters in the device */
>> +       ret = vpfe_config_image_format(vpfe_dev,
>> +                               &vpfe_standards[vpfe_dev-
>>std_index].std_id);
>> +       if (ret)
>> +               goto unlock_out;
>
>Why you check ret value and go to label below?
>Probably you can remove if-check and goto here.
>
Ok.
>> +
>> +unlock_out:
>> +       mutex_unlock(&vpfe_dev->lock);
;
>
>return -EIO?
>
Ok.
>--
>Best regards, Klimov Alexey

