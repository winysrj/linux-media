Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:48254 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307AbZKXJVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 04:21:10 -0500
Date: Tue, 24 Nov 2009 10:21:08 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Purushottam R S <purushottam_r_s@yahoo.com>
Cc: linux-media@vger.kernel.org
Subject: Re: v4l2src output in YUV I420..possible ..?
Message-ID: <20091124102108.30c7ed8a@tele>
In-Reply-To: <947768.69880.qm@web94702.mail.in2.yahoo.com>
References: <947768.69880.qm@web94702.mail.in2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 24 Nov 2009 14:23:47 +0530 (IST)
Purushottam R S <purushottam_r_s@yahoo.com> wrote:

> Is it possible to get the camera output (v4l2src) in YUV I420 format.
> Older version of gspca (v4lsrc) was giving in this format.
	[snip]

Hello Purush,

In the old gspca v1, the JPEG image decoding was done by the driver: you
did not see it. Now, this job is done by the applications. You may use
the v4l library to retrieve the old behaviour.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
