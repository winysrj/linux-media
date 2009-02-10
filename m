Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f176.google.com ([209.85.218.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LWiuE-0001kZ-N7
	for linux-dvb@linuxtv.org; Tue, 10 Feb 2009 04:03:28 +0100
Received: by bwz24 with SMTP id 24so2102629bwz.17
	for <linux-dvb@linuxtv.org>; Mon, 09 Feb 2009 19:02:53 -0800 (PST)
Date: Tue, 10 Feb 2009 04:02:49 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: DVB mailin' list thingy <linux-dvb@linuxtv.org>
Message-ID: <alpine.DEB.2.01.0902100347560.1147@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Subject: [linux-dvb] Stupid beginner-level code question...
Reply-To: linux-media@vger.kernel.org
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

Howdy,

whilst counting interrupts on my machines, I pondered whether
I could double the work one machine could handle by not parsing
a 33Mbit/sec transport stream, but only the PID carrying the
128kbit/sec payload.

I observed the following code for one device, the USB Opera
DVB-S receiver which supposedly delivers the full transponder
stream when attached to a USB2 controller, optionally filtered:

static int opera1_pid_filter_control(struct dvb_usb_adapter *adap, int onoff)
{
        int u = 0x04;
        u8 b_pid[3];
        struct i2c_msg msg[] = {
                {.addr = ADDR_B1A6_STREAM_CTRL,.buf = b_pid,.len = 3},
        };
        if (dvb_usb_opera1_debug)
                info("%s hw-pidfilter", onoff ? "enable" : "disable");
        for (; u < 0x7e; u += 2) {
                b_pid[0] = u;
                b_pid[1] = 0;
                b_pid[2] = 0x80;
                i2c_transfer(&adap->dev->i2c_adap, msg, 1);
        }
        return 0;
}

Full source within dvb-usb/opera1.c; in particular the code which
precedes this and actually sets selected PIDs and is quite 
similar.


Anyway, what bothers me about the above code is that I can't see
that it acts any different, save for possibly printing out a
different debug message, regardless of the intent to enable the
internal hardware PID filter, or disable it and pass the entire
stream.


Or have I been awake too long, and can no longer think or see
straight?

thanks
barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
