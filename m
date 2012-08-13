Return-path: <linux-media-owner@vger.kernel.org>
Received: from web244.extendcp.co.uk ([79.170.40.244]:36145 "EHLO
	web244.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2HMUqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 16:46:44 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: RFC: V4L2 API ambiguities
MIME-Version: 1.0
Date: Mon, 13 Aug 2012 21:27:08 +0100
From: Walter Van Eetvelt <walter@van.eetvelt.be>
Cc: linux-media <linux-media@vger.kernel.org>,
	<workshop-2011@linuxtv.org>
In-Reply-To: <201208131427.56961.hverkuil@xs4all.nl>
References: <201208131427.56961.hverkuil@xs4all.nl>
Message-ID: <8ed2a79057a0cc80ba058cebd97fd69d@mail.eetvelt.be>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 13 Aug 2012 14:27:56 +0200, Hans Verkuil <hverkuil@xs4all.nl>
wrote:
> Hi all!
> 
> As part of the 2012 Kernel Summit V4L2 workshop I will be discussing a
> bunch of
> V4L2 ambiguities/improvements.
...
> 
> If something is unclear, or you think another topic should be added,
then
> let me
> know as well.

For me there is a an issue in the V4L specs for the support of DVB-S/C/T
devices where the CI device is decoupled from the Tuners.  
At the moment there is no standard solution on which device drivers
implementers and Application programmers can fall back.

This is for hardware with multiple tuners and one CI device that can
handle multiple streams (or even streams from different cards).   

The solution should explain how the Tuners are linked to the CI module(s).


The current situation leads to device drivers that are implemented but
that are not (fully) usable in any application.  The application developers
are waiting for API specs to explain how to implement  the CI capabilities.


In my experience a solution for this would bring more users to use
DVB-S/T/C capabilities of Linux (as the average TV user in many countries
uses a payed subscription).  

Walter
