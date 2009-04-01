Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:57250 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbZDARzy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2009 13:55:54 -0400
To: Darius Augulis <augulis.darius@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc_camera_open() not called
References: <49D37485.7030805@gmail.com> <49D3788D.2070406@gmail.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 01 Apr 2009 19:55:39 +0200
In-Reply-To: <49D3788D.2070406@gmail.com> (Darius Augulis's message of "Wed\, 01 Apr 2009 17\:22\:05 +0300")
Message-ID: <87zlf0cl7o.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Darius Augulis <augulis.darius@gmail.com> writes:

> Darius Augulis wrote:
>> Hi,
>>
>> I'm trying to launch mx1_camera based on new v4l and soc-camera tree.
>> After loading mx1_camera module, I see that .add callback is not called.
>> In debug log I see that soc_camera_open() is not called too.
>> What should call this function? Is this my driver problem?
>> p.s. loading sensor driver does not change situation.

Are you by any chance using last 2.6.29 kernel ?
If so, would [1] be the answer to your question ?

Cheers

--
Robert

[1] http://lkml.org/lkml/2009/3/24/625
