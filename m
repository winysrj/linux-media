Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:55683 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZFIT0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 15:26:25 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KKZ001XDKO02CG0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 09 Jun 2009 15:26:25 -0400 (EDT)
Date: Tue, 09 Jun 2009 15:26:18 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
In-reply-to: <829197380906091207s19df864cl50fd14d57abb1dd4@mail.gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: David Ward <david.ward@gatech.edu>, linux-media@vger.kernel.org
Message-id: <4A2EB75A.4070409@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4A2CE866.4010602@gatech.edu> <4A2D4778.4090505@gatech.edu>
 <4A2D7277.7080400@kernellabs.com>
 <829197380906081336n48d6090bmc4f92692a5496cd6@mail.gmail.com>
 <4A2E6FDD.5000602@kernellabs.com>
 <829197380906090723t434eef6dje1eb8a781babd5c7@mail.gmail.com>
 <4A2E70A3.7070002@kernellabs.com> <4A2EAF56.2090508@gatech.edu>
 <829197380906091155u43319c82i548a9f08928d3826@mail.gmail.com>
 <4A2EB233.3080800@kernellabs.com>
 <829197380906091207s19df864cl50fd14d57abb1dd4@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Tue, Jun 9, 2009 at 3:04 PM, Steven Toth <stoth@kernellabs.com> wrote:
>> 40db.
>>
>> --
>> Steven Toth - Kernel Labs
>> http://www.kernellabs.com
>>
> 
> Just checked the source.  It's 40dB for QAM256, but 30dB for ATSC and
> QAM64.  Are we sure he's doing QAM256 and not QAM64?
> 
> Devin
> 

30db for the top end of ATSC sounds about right.

David, when you ran the windows signal monitor - did it claim QAM64 or 256 when 
it was reporting 30db?

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
