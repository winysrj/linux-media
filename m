Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:48992 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZFIOXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 10:23:24 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KKZ00LOY6N09WF0@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 09 Jun 2009 10:23:25 -0400 (EDT)
Date: Tue, 09 Jun 2009 10:23:23 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
In-reply-to: <4A2D7C99.3090609@gatech.edu>
To: David Ward <david.ward@gatech.edu>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Message-id: <4A2E705B.6060905@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4A2CE866.4010602@gatech.edu> <4A2D1CAA.2090500@kernellabs.com>
 <829197380906080717x37dd1fd8n8f37fb320ab20a37@mail.gmail.com>
 <4A2D3A40.8090307@gatech.edu> <4A2D3CE2.7090307@kernellabs.com>
 <4A2D4778.4090505@gatech.edu> <4A2D7277.7080400@kernellabs.com>
 <829197380906081336n48d6090bmc4f92692a5496cd6@mail.gmail.com>
 <4A2D7C99.3090609@gatech.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Ward wrote:
> On 06/08/2009 04:36 PM, Devin Heitmueller wrote:
>> On Mon, Jun 8, 2009 at 4:20 PM, Steven Toth<stoth@kernellabs.com>  wrote:
>>   
>>> We're getting into the realm of 'do you need to amplify and/or debug 
>>> your
>>> cable network', and out of the realm of driver development.
>>>      
> Comcast is coming tomorrow to check out the signal quality.  They said 
> that they expect to deliver SNR in the range of 33dB - 45dB to the 
> premises.  I will let you know how that affects Linux captures.

33 should be fine for any Linux TV device. Make sure the engineer checks for 
33db across a range of the higher (80 thru 100) rf channels (where rf falloff of 
common).

Let us know how you get on.

Regards,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
