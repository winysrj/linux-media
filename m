Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2.dnainternet.fi ([87.94.96.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K2ReT-00029H-2w
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 16:01:46 +0200
Message-ID: <48415A24.5080305@iki.fi>
Date: Sat, 31 May 2008 17:01:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dennis Noordsij <dennis.noordsij@movial.fi>
References: <48414EC8.3080008@movial.fi>
In-Reply-To: <48414EC8.3080008@movial.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] usb-dvb and endpoints question
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Dennis Noordsij wrote:
> Hi list,
> 
> I am writing a driver for the TerraTec Piranha DVB-T USB stick (actually
> the Sanio SMS-1000 chipset). From reading USB logs I have a working
> libusb prototype which can tune and receive the transport stream, and
> use the hardware PID filter.
> 
> Porting it to a proper linux DVB driver I have the following question:
> 
> This device has exactly 2 bulk endpoints, as follows:
> 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               0
> 
> All control messages go out over EP2. All responses, as well as the
> transport stream, come in over EP1.

uh, very crazy solution :o

> All incoming packets have a small header which allows it to be mapped
> back to the corresponding request (excepting TS data which can be read
> spontaneously, but which is still marked with an additional header).
> 
> Does this mean that I can not really use the dvb-usb framework ? (since
> there is no generic_bulk_ctrl_endpoint, and since the TS stream also
> does not come on its own endpoint and even needs additional depackatizing).

Looks like it is not possible to use dvb-framework very much...

...But you can use generic_bulk_ctrl_endpoint & generic_write to write 
data if you can use dvb-framework partially. But reading data could be 
very hard to implement.

> Since incoming data is mixed with TS packets, you can no longer just
> write a command and read the next response. TS data will be streaming in
> and every time you make some request you will probably get some TS data
> first, and only then your response. How to solve?
> 
> Any pointers in the right direction? :-)

Other thoughts, wMaxPacketSize 0x0040 1x 64 bytes looks rather small for TS.

Can you provide sample usb-sniff from windows? Parsed with usb-replay 
parser.pl -script would be enough if whole sniff is very large.

> Cheers,
> Dennis

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
