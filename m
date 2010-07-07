Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239Ab0GGPId (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jul 2010 11:08:33 -0400
Message-ID: <4C34986C.6020806@redhat.com>
Date: Wed, 07 Jul 2010 12:08:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC/PATCH 2/6] v4l: subdev: Add device node support
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278503608-9126-3-git-send-email-laurent.pinchart@ideasonboard.com> <A69FA2915331DC488A831521EAE36FE4016B5EDCD7@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4016B5EDCD7@dlee06.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-07-2010 11:14, Karicheri, Muralidharan escreveu:
> 
> 
>> v4l2_device *v4l2_dev,
>> 		if (err && err != -ENOIOCTLCMD) {
>> 			v4l2_device_unregister_subdev(sd);
>> 			sd = NULL;
>> +		} else {
>> +			sd->initialized = 1;
>> 		}
> 
> Wouldn't checkpatch.pl script complain about { } on the else part since
> there is only one statement?  

IMO, it is because it analyzes the entire if clause. As the first part of the if has two
statements, CodingStyle accepts the usage of braces at the second part 
(although this is not a common practice).

>> 	}
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

