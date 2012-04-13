Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49019 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951Ab2DMTXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 15:23:24 -0400
References: <4F88739A.4020401@gmail.com>
In-Reply-To: <4F88739A.4020401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: media_build compile errors
From: Andy Walls <awalls@md.metrocast.net>
Date: Fri, 13 Apr 2012 15:23:22 -0400
To: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <6160cbc5-9493-44bf-9da1-57b96493fdca@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Roger Mårtensson" <roger.martensson@gmail.com> wrote:

>Hi!
>
>I get compile errors when trying to build media_build as of 2012-04-13.
>
>/home/mythfrontend/media_build/v4l/ivtv-fileops.c: In function 
>'ivtv_v4l2_enc_poll':
>/home/mythfrontend/media_build/v4l/ivtv-fileops.c:751:2: error:
>implicit 
>declaration of function 'poll_requested_events' 
>[-Werror=implicit-function-declaration]
>cc1: some warnings being treated as errors
>
>This is on ubuntu and kernel:
>Linux 3.0.0-16-generic #29-Ubuntu SMP Tue Feb 14 12:49:42 UTC 2012 i686
>
>i686 i386 GNU/Linux
>
>Anyone else seeing this problem?
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

poll_requested_events() likely only exists is very recent kernels.  
To build with older kernels you need to either change the relevant ivtv function by hand, or wait for someone to submit a backward compatability patch for the media_build repo.

Regards,
Andy
