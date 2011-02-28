Return-path: <mchehab@pedra>
Received: from postfix.mbigroup.it ([84.233.239.88]:53402 "EHLO
	postfix.mbigroup.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab1B1LMy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 06:12:54 -0500
Message-ID: <4D6B832C.7020704@mbigroup.it>
Date: Mon, 28 Feb 2011 12:12:44 +0100
From: Vinicio Nocciolini <vnocciolini@mbigroup.it>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: ec168-9295d36ab66e compiling error
References: <4D666A3A.1090701@mbigroup.it> <4D6A9388.5030001@iki.fi> <4D6B7AD6.1050309@mbigroup.it> <4D6B7B7D.60308@iki.fi>
In-Reply-To: <4D6B7B7D.60308@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 02/28/2011 11:39 AM, Antti Palosaari wrote:
> On 02/28/2011 12:37 PM, Vinicio Nocciolini wrote:
>> [ 304.722224] dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference design'
>> in cold state, will try to load a firmware
>> [ 304.742587] dvb-usb: did not find the firmware file.
>> (dvb-usb-ec168.fw) Please see linux/Documentation/dvb/ for more details
>> on firmware-problems. (-2)
>
> That error message should be rather clear. Use Google to find correct 
> firmware.
>
> Antti
>
>

root@localhost ~]# w_scan -c IT
w_scan version 20110206 (compiled for DVB API 5.2)
using settings for SPAIN
DVB aerial
DVB-T Europe
frontend_type DVB-T, channellist 4
output format vdr-1.6
Info: using DVB adapter auto detection.
main:3030: FATAL: ***** NO USEABLE DVB CARD FOUND. *****
Please check wether dvb driver is loaded and
verify that no dvb application (i.e. vdr) is running.
