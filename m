Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55307 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671AbZFKOoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 10:44:07 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: =?iso-8859-1?Q?Jean-Philippe_Fran=E7ois?= <jp.francois@cynove.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 11 Jun 2009 09:43:44 -0500
Subject: RE: mt9t031 (was RE: [PATCH] adding support for setting bus
           parameters in sub device)
Message-ID: <A69FA2915331DC488A831521EAE36FE40139A09002@dlee06.ent.ti.com>
References: <42113.62.70.2.252.1244712785.squirrel@webmail.xs4all.nl>
 <4A30D101.3090207@redhat.com>
In-Reply-To: <4A30D101.3090207@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>
>> - video streaming devices like the davinci videoports where you can hook
>> up HDTV receivers or FPGAs: here you definitely need a new API to setup
>> the streaming parameters, and you want to be able to do that from the
>> application as well. Actually, sensors are also hooked up to these
>devices
>> in practice. And there you also want to be able to setup these parameters.
>> You will see this mostly (only?) on embedded platforms.
>>
>
>I agree we need an in kernel API for this, but why expose it to
>userspace, as you say this will only happen on embedded systems,
>shouldn't the info then go in a board_info file / struct ?
>
No we still need a way for application to set these timings at the device. For example, it needs to tell a TVP7002 device to scan at 720p/1080p similar to S_STD. From user prespective, it is just like S_STD. See my email on the details...

>Regards,
>
>Hans

