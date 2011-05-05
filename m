Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:22260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab1EELE4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 07:04:56 -0400
Message-ID: <4DC28445.8050003@redhat.com>
Date: Thu, 05 May 2011 08:04:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>, tomekbu@op.pl,
	Steven Stoth <stoth@kernellabs.com>,
	Jonathan Corbet <corbet@lwn.net>,
	=?ISO-8859-1?Q?Hern=E1n_Ordiales?= <h.ordiales@gmail.com>,
	Hans Verkuil <hansverk@cisco.com>,
	"Igor M. Liplianin" <liplianin@me.by>,
	David Cohen <dacohen@gmail.com>
Subject: Re: Patches still pending at linux-media queue (18 patches)
References: <4DC2207B.5030700@redhat.com> <4DC26024.2080809@maxwell.research.nokia.com>
In-Reply-To: <4DC26024.2080809@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-05-2011 05:30, Sakari Ailus escreveu:
> Mauro Carvalho Chehab wrote:
>> 		== waiting for Sakari Ailus <sakari.ailus@maxwell.research.nokia.com> submission == 
>>
>> Sakari,
>>
>> 	I'm understanding that you'll be handling this one.
>>
>> Feb,19 2011: [RFC/PATCH,1/1] tcm825x: convert driver to V4L2 sub device interface   http://patchwork.kernel.org/patch/574931  David Cohen <dacohen@gmail.com>
> 
> Hi Mauro,
> 
> This is mine and David's long term task. :-)
> 
> The tcm825x is the other user of the old v4l2-int-device framework, the
> one being omap24xxcam. Both are used on the N8[01]0.
> 
> Conversion of both of the drivers should go in at the same time. Then
> the v4l2-int-device framework can be removed. I'll work with David on
> this. (Cc David.)

Thanks! I'll mark this as RFC at patchwork, as you may probably need to
do another round on it.

Thanks,
Mauro
