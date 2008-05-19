Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <morgan.torvolt@gmail.com>) id 1Jy3W1-0005R5-Qd
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 13:26:57 +0200
Received: by wa-out-1112.google.com with SMTP id n7so1635581wag.13
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 04:26:48 -0700 (PDT)
Message-ID: <3cc3561f0805190426m5b7dce4bxfed33ad9f5d1339@mail.gmail.com>
Date: Mon, 19 May 2008 13:26:47 +0200
From: "=?ISO-8859-1?Q?Morgan_T=F8rvolt?=" <morgan.torvolt@gmail.com>
To: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAATOXWIs2RXki66Y//Z0YPkgEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <47967.203.200.233.131.1210684391.squirrel@203.200.233.138>
	<!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAATOXWIs2RXki66Y//Z0YPkgEAAAAA@tv-numeric.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] RE : inserting user PIDs in TS
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

I am not sure that I agreen on having to modify PCR even if you add
data to the mux. Every service has it's own PCR, If you add a new pid
without PCR, then you just have to increase output datarate
accordingly. As long as the PCR leaves the muxing software at the same
time as it would do without injecting the pid, there should be no
difference at the receiving end. You should be able to inject any
ammount of pids and data as long as you don't introduce a lot of PCR
jitter (given that the receiving end can handle the increased datarate
of course)

-Morgan-



On 13/05/2008, Thierry Lelegard <thierry.lelegard@tv-numeric.com> wrote:
> >I would like to know that can we insert user defined PIDs into the TS
>  >stream. how should i go about? What standard should i follow? How should I
>  >format the the packets ( segment - section etc...).
>  >can any body help in this regard.
>
>
> Yes, in theory, you can.
>
>  Keep in mind, however, that multiplexing is a quite difficult job
>  (this is what multiplexers are made for).
>
>  Several issue (no specific order):
>
>  - What is your target application in the STB? What kind of data does it
>  expect? How does it determine the data PID?
>
>  - Selecting a data format. If you target an EPG as your previous postings
>  suggest, you need to build EIT-schedule sections. See ETSI EN 300 468,
>  "Digital Video Broadcasting (DVB); Specification for Service Information
>  (SI) in DVB systems".
>
>  - Build TS packets from sections. See ISO/IEC 13818-1, "Information technology,
>  Generic coding of moving pictures and associated audio information: Systems"
>  (a.k.a. "MPEG-2 system layer"). Also be careful to update continuity counters.
>
>  - Insert TS packets in the transport stream. Several possibilities:
>
>  1) Really "insert" (ie. "add") packets in the TS. Note that this will increase
>  the bitrate of the TS, which may be a problem depending on the transport medium.
>  You will also have to resample all PCR's, which can be very tricky.
>
>  2) Replace existing packets with yours, without deleting any. This way, the
>  bitrate of the TS remains the same and you do not need to modify the PCR.
>  Now, the question is "which packets should I replace?" since these packets
>  will be deleted from the TS. Two possibilities:
>
>  2.1) If your data naturally replace one PID, replace all packets from this
>  PID. If you want to replace the EIT for instance, replace all packets from
>  PID 0x0012. But keep in mind that this PID potentially contains 4 types of
>  EIT's: schedule and present/following, both either "actual" or "other".
>  So, if you replace only one type of EIT, be cautious to keep to others
>  and to reinject them in your rebuilt PID.
>
>  2.2) If you create a new PID, the simplest method is to "steal" stuffing
>  packets (any packet from PID 0x1FFF). Most TS contain stuffing, sometimes
>  more than 1 Mb/s of stuffing. If your required data rate is less than the
>  suffing rate of the TS, this is the simplest method.
>
>  - Finally, make sure your PID is referenced somewhere, in accordance with
>  your application: predefined standard PID such as 0x0012 for EIT or as a
>  component of a service in a PMT, or as a new data service with a dedicated
>  PMT (also require to update the PAT and optionally the SDT and NIT).
>  Remember that if your TS is going through a MUX, PID remapping may occur
>  and your TS need to be consistent from the beginning.
>
>  I have already done all of this (creating sections, packetizing them,
>  stealing stuffing, adding components in a PMT, etc). It works quite well
>  but it is not really easy without the appropriate tools (you need to code
>  everything yourself).
>
>
>  -Thierry
>
>
>
>  _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
