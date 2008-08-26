Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Oliver Neukum <oliver@neukum.org>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Date: Tue, 26 Aug 2008 21:28:42 +0200
References: <Pine.LNX.4.44L0.0808261430330.2139-100000@iolanthe.rowland.org>
	<48B451B5.7050802@hhs.nl>
In-Reply-To: <48B451B5.7050802@hhs.nl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808262128.43886.oliver@neukum.org>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	linux-usb <linux-usb@vger.kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [v4l-dvb-maintainer] [patch]dma on stack in dib0700
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

Am Dienstag 26 August 2008 20:55:49 schrieb Hans de Goede:
> I see, so basicly the only safe buffer for usb_control_msg is one that is 
> kmalloc -ed all by itself with no other use for that kmalloc block then using 
> it for usb_comtrol_msg, iow the buffer may not be allocated as anything that is 
> part of a larger memory block such as a struct or an array?

That's the rule to follow.

> And we then could allocate 32 bytes, because we might as well as that is the 
> minimum kmalloc block size, or MUST we allocate 32 bytes to make sure we get a 
> cache-line all by ourselves?

Anything kmalloc returns is safe. You might just as well allocate 32 bytes
you don't have to. kmalloc on the affected architectures will round up to
cache line size.

	Regards
		Oliver


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
