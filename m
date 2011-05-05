Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:23862 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab1EEI1z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 04:27:55 -0400
Message-ID: <4DC26024.2080809@maxwell.research.nokia.com>
Date: Thu, 05 May 2011 11:30:28 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>, tomekbu@op.pl,
	Steven Stoth <stoth@kernellabs.com>,
	Jonathan Corbet <corbet@lwn.net>,
	=?ISO-8859-1?Q?Hern=E1n_Ordiales?= <h.ordiales@gmail.com>,
	Hans Verkuil <hansverk@cisco.com>,
	"Igor M. Liplianin" <liplianin@me.by>,
	David Cohen <dacohen@gmail.com>
Subject: Re: Patches still pending at linux-media queue (18 patches)
References: <4DC2207B.5030700@redhat.com>
In-Reply-To: <4DC2207B.5030700@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro Carvalho Chehab wrote:
> 		== waiting for Sakari Ailus <sakari.ailus@maxwell.research.nokia.com> submission == 
> 
> Sakari,
> 
> 	I'm understanding that you'll be handling this one.
> 
> Feb,19 2011: [RFC/PATCH,1/1] tcm825x: convert driver to V4L2 sub device interface   http://patchwork.kernel.org/patch/574931  David Cohen <dacohen@gmail.com>

Hi Mauro,

This is mine and David's long term task. :-)

The tcm825x is the other user of the old v4l2-int-device framework, the
one being omap24xxcam. Both are used on the N8[01]0.

Conversion of both of the drivers should go in at the same time. Then
the v4l2-int-device framework can be removed. I'll work with David on
this. (Cc David.)

Kind regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
