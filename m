Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57364 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab3FBVCt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jun 2013 17:02:49 -0400
Message-ID: <51ABB2D1.6080908@iki.fi>
Date: Mon, 03 Jun 2013 00:02:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Petter Selasky <hps@bitfrost.no>
CC: unlisted-recipients:; linux-media@vger.kernel.org,
	Juergen Lock <nox@jelal.kn-bremen.de>
Subject: Re: TT-USB2.0 and high bitrate packet loss (DVB-C/T)
References: <51A70713.6030802@bitfrost.no> <51AB385A.4040701@bitfrost.no>
In-Reply-To: <51AB385A.4040701@bitfrost.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/2013 03:19 PM, Hans Petter Selasky wrote:
> On 05/30/13 10:00, Hans Petter Selasky wrote:
>> Hi there,
>>
>> I need to get in concat with someone that can handle, test and review a
>> patch for TT-USB2.0. I've found that for certain high-bitrate streams,
>> the TT-USB2.0 sends more ISOCHRONOUS MPEG data than is specified in the
>> wMaxPacketSize fields. I have a USB analyzer capture which shows this
>> clearly. This of course won't be received at the USB host and packet
>> drops appear inside the stream. The solution is to use another alternate
>> setting. The technotrend chip has many of these. I've now tested using
>> alternate setting 7 instead of 3.
>>
>> Alternate setting 7 allows transferring a maximum of 3 * 1024 bytes.
>> Alternate setting 3 allows transferring a maximum of 1 * 940 bytes.
>>
>> --HPS
>
> Hi,
>
> It turns out that this device, at least the version I bought, does not
> work with the XHCI at all when using multi-packet transfers, alternate
> setting 7, because DATA2 PID is used when transfer is less than 1024
> bytes. It should be DATA0 PID first, then 1 and 2 in the end. Probably a
> firmware update can fix this, but I'm not aware about if such exists.
> The PID issue was found using a USB analyzer.
>
> Apparently this bug has gone undetected, because at least the EHCI high
> speed only controller I've got silently ignores this kind of errors and
> receives the data whilst the XHCI not. Conclusion:
> Existing alternate setting must be used.
>
> I think I will have to get another USB based receiver with CI slot. Any
> recommendations for DVB-T ?

There is no many alternatives available. I suspect Anysee E7 serie is 
the only one. And I am not even sure if its CI works anymore. Lastly 
when I tested it I didn't get scrambled channels working - but it could 
be due to card entitlements were not upgraded. Anyhow, if there is bug 
then it should be easy to fix.

regards
Antti

-- 
http://palosaari.fi/
