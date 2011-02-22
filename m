Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:59841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab1BVKqg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 05:46:36 -0500
Message-ID: <4D63941C.1060602@redhat.com>
Date: Tue, 22 Feb 2011 11:46:52 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mike Booth <mike_booth76@iprimus.com.au>
CC: linux-media@vger.kernel.org
Subject: Re: v4l-utils-0.8.3 and KVDR
References: <e05367$6n6fju@smtp06.syd.iprimus.net.au>
In-Reply-To: <e05367$6n6fju@smtp06.syd.iprimus.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 02/22/2011 10:03 AM, Mike Booth wrote:
> KVDR has a number of different parameters including
>
> -x                        force xv-mode on startup and disable overlay-mod
>
> -d                        dont switch modeline during xv
>   with kernel 2.6.35 I run KVDR with -x as I have an NVIDIA graphics. Running
> on 2.6.38 KVDR -x doesn't produce any log. The display appears and immediately
> disappears although there is a process running.
>

So with 2.6.35 and v4l-utils-0.8.3 things work ? Then this is not a libv4l
problem, as libv4l will no longer use the kernels v4l1 compat independent of
the kernels version.

Also in the log I see nothing indicating this is a v4l1 app (I'm not familiar
with kvdr), so I think something else may have changed in the new
kernel causing your issue.

Regards,

Hans
