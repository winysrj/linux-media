Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:47844 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab0AYJzX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 04:55:23 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NZLfB-0007VK-Gx
	for linux-media@vger.kernel.org; Mon, 25 Jan 2010 10:55:17 +0100
Received: from 92.103.125.220 ([92.103.125.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 10:55:17 +0100
Received: from ticapix by 92.103.125.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 10:55:17 +0100
To: linux-media@vger.kernel.org
From: "pierre.gronlier" <ticapix@gmail.com>
Subject: Re: problem with libdvben50221 and powercam pro V4 [almost solved]
Date: Mon, 25 Jan 2010 10:54:51 +0100
Message-ID: <4B5D6A6B.9030900@gmail.com>
References: <4B5CA8F8.3000301@crans.ens-cachan.fr> <1a297b361001241322q2b077683v8ac55b35afb4fe97@mail.gmail.com> <4B5CBF14.1000005@crans.ens-cachan.fr> <loom.20100124T225424-639@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20100124T225424-639@post.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pierre gronlier wrote, On 01/24/2010 11:03 PM:
> DUBOST Brice <dubost <at> crans.ens-cachan.fr> writes:
>> Manu Abraham a écrit :
>>> Hi Brice,
>>>
>>> On Mon, Jan 25, 2010 at 12:09 AM, DUBOST Brice
>>> <dubost <at> crans.ens-cachan.fr> wrote:
>>>> Hello
>>>>
>>>> Powercam just made a new version of their cam, the version 4
>>>>
>>>> Unfortunately this CAM doesn't work with gnutv and applications based on
>>>> libdvben50221
>>>>
>>>> This cam return TIMEOUT errors (en50221_stdcam_llci_poll: Error reported
>>>> by stack:-3) after showing the supported ressource id.
>>>>
>>>> The problem is that this camreturns two times the list of supported ids
>>>> (as shown in the log) this behavior make the llci_lookup_callback
>>>> (en50221_stdcam_llci.c line 338)  failing to give the good ressource_id
>>>> at the second call because there is already a session number (in the
>>>> test app the session number is not tested)
>>>>
>>>> I solved the problem commenting out the test for the session number as
>>>> showed in the joined patch (against the latest dvb-apps, cloned today)
> 
> I will run some tests with a TT3200 card too and a Netup card tomorrow.
> 
> Regarding the cam returning two times the list of valid cam ids, wouldn't be
> better if the manufacturer corrects it in the cam firmware ?
> What says the en50221 norm about it ?
> 

Indeed, with the patch applied, the command gnutv -adapter 0 -cammenu is
working fine with a netup card too.

I will try to update to the last revision of pcam firmware (v4.2) and
report this behaviour to the manufacturer.

-- 
Pierre


