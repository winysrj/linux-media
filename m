Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:35782 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab2D0JXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:23:50 -0400
Date: Fri, 27 Apr 2012 11:24:43 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org,
	Erik =?UTF-8?B?QW5kcsOpbg==?= <erik.andren@gmail.com>
Subject: Re: [RFC PATCH 3/3] [media] gspca - main: implement
 vidioc_g_ext_ctrls and vidioc_s_ext_ctrls
Message-ID: <20120427112443.7edd32f3@tele>
In-Reply-To: <201204271020.23880.hverkuil@xs4all.nl>
References: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it>
	<1334935152-16165-1-git-send-email-ospite@studenti.unina.it>
	<1334935152-16165-4-git-send-email-ospite@studenti.unina.it>
	<201204271020.23880.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Apr 2012 10:20:23 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> I might have some time (no guarantees yet) to help with this. It would
> certainly be interesting to add support for the control framework in the
> gspca core. Hmm, perhaps that's a job for the weekend...

Hi Hans,

I hope you will not do it! The way gspca treats the controls is static,
quick and very small. The controls in the subdrivers ask only for the
declaration of the controls and functions to send the values to the
webcams. Actually, not all subdrivers have been converted to the new
gspca control handling, but, when done, it will save more memory.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
