Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:39270 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaJIUjY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Oct 2014 16:39:24 -0400
Received: by mail-pd0-f170.google.com with SMTP id p10so370946pdj.15
        for <linux-media@vger.kernel.org>; Thu, 09 Oct 2014 13:39:23 -0700 (PDT)
Message-ID: <5436F253.7060203@gmail.com>
Date: Fri, 10 Oct 2014 02:08:43 +0530
From: Alaganraj Sandhanam <alaganraj.sandhanam@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: omap3isp Device Tree support status
References: <20140928221341.GQ2939@valkosipuli.retiisi.org.uk> <54330499.50905@gmail.com> <20141008113303.GY2939@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141008113303.GY2939@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 08 October 2014 05:03 PM, Sakari Ailus wrote:
> Hi Alaganjar,
> 
> On Tue, Oct 07, 2014 at 02:37:37AM +0530, Alaganraj Sandhanam wrote:
>> Hi Sakari,
>>
>> Thanks for the patches.
>> On Monday 29 September 2014 03:43 AM, Sakari Ailus wrote:
>>> Hi,
>>>
>>> I managed to find some time for debugging my original omap3isp DT support
>>> patchset (which includes smiapp DT support as well), and found a few small
>>> but important bugs.
>>>
>>> The status is now that images can be captured using the Nokia N9 camera, in
>>> which the sensor is connected to the CSI-2 interface. Laurent confirmed that
>>> the parallel interface worked for him (Beagleboard, mt9p031 sensor on
>>> Leopard imaging's li-5m03 board).
>> Good news!
>>>
>>> These patches (on top of the smiapp patches I recently sent for review which
>>> are in much better shape) are still experimental and not ready for review. I
>>> continue to clean them up and post them to the list when that is done. For
>>> now they can be found here:
>>>
>>> <URL:http://git.linuxtv.org/cgit.cgi/sailus/media_tree.git/log/?h=rm696-043-dt>
>>>
>> I couldn't clone the repo, getting "remote corrupt" error.
>>
>> $ git remote -v
>> media-sakari	git://linuxtv.org/sailus/media_tree.git (fetch)
>> media-sakari	git://linuxtv.org/sailus/media_tree.git (push)
>> origin	git://linuxtv.org/media_tree.git (fetch)
>> origin	git://linuxtv.org/media_tree.git (push)
>> sakari	git://vihersipuli.retiisi.org.uk/~sailus/linux.git (fetch)
>> sakari	git://vihersipuli.retiisi.org.uk/~sailus/linux.git (push)
>>
>> $ git fetch media-sakari
>> warning: cannot parse SRV response: Message too long
>> remote: error: Could not read 5ea878796f0a1d9649fe43a6a09df53d3915c0ef
>> remote: fatal: revision walk setup failed
>> remote: aborting due to possible repository corruption on the remote side.
>> fatal: protocol error: bad pack header
> 
> I'm not sure what this could be related. Can you fetch from other trees,
> e.g. your origin remote? Do you get the same error from the remote on
> vihersipuli, and by using http instead?
> 
I'm able to fetch from "origin" and "vihersipuli" remotes.
problem with only "git://linuxtv.org/sailus/media_tree.git" remote.

Thanks&Regards
Alaganraj
