Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KCBs0-0001Me-T5
	for linux-dvb@linuxtv.org; Fri, 27 Jun 2008 13:12:02 +0200
Received: by rv-out-0506.google.com with SMTP id b25so485319rvf.41
	for <linux-dvb@linuxtv.org>; Fri, 27 Jun 2008 04:11:55 -0700 (PDT)
Message-ID: <d9def9db0806270411tc6bea85i5a72a9b41c10bad0@mail.gmail.com>
Date: Fri, 27 Jun 2008 13:11:55 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: free_beer_for_all@yahoo.com
In-Reply-To: <296934.88903.qm@web46102.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <296934.88903.qm@web46102.mail.sp1.yahoo.com>
Cc: mrechberger@empiatech.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Potential Linux support for new TerraTec Cinergy
	HTC USB XS HD ?
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

On Fri, Jun 27, 2008 at 11:39 AM, barry bouwsma
<free_beer_for_all@yahoo.com> wrote:
> Moin!
>
> I'm sure it's far too early, but I thought I'd ask just in case
> someone might know more than I do...
>
> Sometime Real Soon Now or Right About Now there should be available
> a new USB device from TerraTec, capable of supporting DVB-C and DVB-T,
> as well as analog radio/TV, and with a USB2 connection (vital for
> successful DVB-C viewing, not critical for SDTV over DVB-T).
>
> Unfortunately, I haven't found detailed hardware info, and what I have
> found refers to ``USB 2.0 compatible'', which sounds to me that it
> might really be a USB 1 device with inadequate bandwidth for HDTV
> or high quality SDTV, like the Cinergy Piranha...
>

it is a full USB 2.0 compatible device, possibly with PID filtering to
support USB 1.1

> Can anyone say if this device could potentially be supported in the
> future, either by vendor-supplied drivers, or by containing supported/
> supportable chipsets within?  I suspect it may be some weeks before
> anyone can.
>
>
> There's some Vista/XP 32/64-bit drivers available from TerraTec
> recently for download.  Perhaps there will be come useful info
> within directory
> Cinergy HTC USB XS HD/BDA Driver 5.8.430.0/
> such as
> ; Cinergy HTC USB XS (EM2883 DVB-T & DVB-C & analog TV/FM & audio)
> %Cinergy.DeviceDesc% = Cinergy.NTx86,USB\VID_0CCD&PID_008E
> or
> ;;;HKR,settings\OEMSettings,TunerID7        ,0x00010001,21     ;CFG7 = SAM9082
>
>
> I don't have the device; my inquiries about availability have not
> yet turned up positive so I'm not able to think about ordering one,
> but if someone has more info or better contacts, and could say
> something definitive (like, maybe, or no way) then I'd love to hear
> it.  Searches have turned up heaps of press releases but no obvious
> technical info.  Of course, it's way early.
>
>
>
> If I understand correctly, there are no simple DVB-C devices out there
> that have a true USB2 interface, which are supported under Linux,
> other than a few significantly more expensive devices, most with
> CAM/CI support, which doesn't interest me, so this has caught my
> attention.  Also being a hybrid, though conveniently switching
> between DVB-T and DVB-C is certainly not practical with one RF input
>
>

It's an Empia based design with the latest available Hardware components.
There have been discussions about those devices and as far as I can
write support is planned for it.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
