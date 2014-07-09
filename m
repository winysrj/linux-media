Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay004-omc2s6.hotmail.com ([65.54.190.81]:57752 "EHLO
	BAY004-OMC2S6.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaGIKzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 06:55:37 -0400
Message-ID: <BAY176-W4659BEC4FE091329110E3AA90F0@phx.gbl>
From: Divneil Wadhawan <divneil@outlook.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: No audio support in struct v4l2_subdev_format
Date: Wed, 9 Jul 2014 16:25:37 +0530
In-Reply-To: <BAY176-W46A88AA74FC1924DEFE69FA90D0@phx.gbl>
References: <BAY176-W7B3F24A204E68896226E0A9000@phx.gbl>,<53B65DCA.6010803@xs4all.nl>,<BAY176-W23C9AA5FB70F17EDEB68F8A9000@phx.gbl>,<53B679C2.7030002@xs4all.nl>,<BAY176-W32B9E16B0436D20DF363BEA9000@phx.gbl>,<53B6840A.20102@xs4all.nl>,<BAY176-W264D5BED6FA556ABDE0763A9000@phx.gbl>,<53B7BA57.1010003@xs4all.nl>,<BAY176-W46A88AA74FC1924DEFE69FA90D0@phx.gbl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


I agree that it was not a good implementation of using event.

(Please discard the exact code, as it is erroneous in managing ctrl events replace/merge and other ones)


I restart with the concern.

Here, I have a v4l2 subdev, which can generate events from the time we load it.

We later found some use cases, where we would like the application to get the events too.


v4l2_event_queue_fh() requires fh. 

I think, there's no way of gaining the access to this fh, except the SUBSCRIBE_EVENT or any calls landing on subdev before this.

The adding and deleting of fh in the list, is well managed by the event ops.

However, adding fh to the list is the tricky part, as I don't want to fill in the link list with the same fh over and over.


If you know of any other way, please suggest.

I hope I clarified the point this time.


Regards,

Divneil 		 	   		  