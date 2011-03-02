Return-path: <mchehab@pedra>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:32229 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab1CBJeQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 04:34:16 -0500
Message-ID: <4D6E0F16.5090809@cisco.com>
Date: Wed, 02 Mar 2011 10:34:14 +0100
From: "Martin Bugge (marbugge)" <marbugge@cisco.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <daniel-gl@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC] HDMI-CEC proposal
References: <4D6CC36B.50009@cisco.com> <20110301233806.GA4969@minime.bse>
In-Reply-To: <20110301233806.GA4969@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/02/2011 12:38 AM, Daniel Glöckner wrote:
> On Tue, Mar 01, 2011 at 10:59:07AM +0100, Martin Bugge (marbugge) wrote:
>    
>> CEC is a protocol that provides high-level control functions between
>> various audiovisual products.
>> It is an optional supplement to the High-Definition Multimedia
>> Interface Specification (HDMI).
>> Physical layer is a one-wire bidirectional serial bus that uses the
>> industry-standard AV.link protocol.
>>      
> Apart from CEC being twice as fast as AV.link and using 3.6V
> instead of 5V, CEC does look like an extension to the frame format
> defined in EN 50157-2-2 for multiple data bytes.
>
> So, how about adding support for EN 50157-2-* messages as well?
> SCART isn't dead yet.
>
> EN 50157-2-1 is tricky in that it requires devices to override
> data bits like it is done for ack bits to announce their status.
> There is a single message type with 21 bits.
>
> For EN 50157-2-2 the only change necessary would be to tell the
> application that it has to use AV.link commands instead of CEC
> commands. In theory one could mix AV.link and CEC on a single
> wire as they can be distinguished by their start bits.
>
> EN 50157-2-3 allows 7 vendors to register their own applications
> with up to 100 data bits per message. I doubt we can support
> these if they require bits on the wire to be modified.
> As they still didn't make use of the reserved value to extend the
> application number space beyond 7, chances are no vendor ever
> applied for a number.
>
> Just my 2 cents.
>
>    Daniel
>    

Hi Daniel and thank you.

I haven't read these standards myself but will do so as soon as I get 
hold of them.
But this sounds like a good idea since cec is based on these protocols.

I will look into it.

Regards,
Martin

