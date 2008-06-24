Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marko.ristola@kolumbus.fi>) id 1KBEXa-0000jF-7k
	for linux-dvb@linuxtv.org; Tue, 24 Jun 2008 21:50:59 +0200
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id 53F6C18D356
	for <linux-dvb@linuxtv.org>; Tue, 24 Jun 2008 22:50:53 +0300 (EEST)
Received: from kuusi.koti (a88-112-30-40.elisa-laajakaista.fi [88.112.30.40])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id 3E0184BB6B
	for <linux-dvb@linuxtv.org>; Tue, 24 Jun 2008 22:50:52 +0300 (EEST)
Message-ID: <4861501B.9050507@kolumbus.fi>
Date: Tue, 24 Jun 2008 22:50:51 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Ticlkess Mantis remote control implementation
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


Hi,

I have still my own version of Manu's jusst.de/mantis driver that is 
based on v4l-dvb-linuxtv main branch,
mainly because I use so new Linux kernels.
I have done the following improvement lately:

I implemented a remote control patch, that doesn't poll the remote 
control all the time.
It polls the remote control only if you press the button (a tickless 
version, you know).
It surprised me, that the actual implementation was really small, it 
took very few lines of code.


The idea is, that the remote control informs (thrue irq) 
mantis_query_rc() to be active.
mantis_query_rc takes care that it will reactivate itself after 250ms, 
until remote control
hasn't sent any "user is still pressing a button" messages.

POLL_FREQ (HZ/4) time (250ms) must be more than the remote control 
message interval (230ms).
This way we can ensure that the remote control sends at least one 
message per POLL_FREQ tick.
If on the last POLL_FREQ tick no button is pressed (-1), 
mantis_query_rc() doesn't activate the POLL_FREQ tick
anymore, just informs via ir_input_nokey() that the remote control user 
doesn't press any buttons.

So in this way the remote control works with Twinhan 2033 better than 
ever (the hand experience is good also).
+ Initial key press is delivered instantly.
+ No CPU consumption while the remote control isn't used.
Could possibly be improved with a tasklet, if the instant response 
experience would be that important.
Can be used from 1 to 4 key repeats per second (230ms remote control 
limit is the lower bound, we must be safely above).

Interrupt handler on mantis_pci.c:
        if (stat & MANTIS_INT_IRQ1) {
                mantis->ir.ir_last_code = mmread(0xe8);
                dprintk(verbose, MANTIS_DEBUG, 0, "* INT IRQ-1 *");
                schedule_delayed_work(&mantis->ir.rc_query_work, 0);
        }
 


mantis_rc.c:
#define POLL_FREQ (HZ/4)

void mantis_query_rc(struct work_struct *work)
{
        struct mantis_pci *mantis =
                container_of(work, struct mantis_pci, 
ir.rc_query_work.work);
        struct ir_input_state *ir = &mantis->ir.ir;

        u32 lastkey = mantis->ir.ir_last_code;

        ir_input_nokey(mantis->ir.rc_dev, ir);

        if (lastkey != -1) {
                ir_input_keydown(mantis->ir.rc_dev, ir, lastkey, 0);
                mantis->ir.ir_last_code = -1;
                schedule_delayed_work(&mantis->ir.rc_query_work, POLL_FREQ);
        }
}

int mantis_rc_init(struct mantis_pci *mantis):
        mantis->ir.ir_last_code = -1; /* key presses disabled here. */
        INIT_DELAYED_WORK(&mir->rc_query_work, mantis_query_rc);

int mantis_rc_exit(struct mantis_pci *mantis):

        mmwrite(mmread(MANTIS_INT_MASK) & (~MANTIS_INT_IRQ1), 
MANTIS_INT_MASK);
        mantis->ir.ir_last_code = -1; /* key presses disabled here. */
        cancel_delayed_work_sync(&mantis->ir.rc_query_work); /* not my 
idea */


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
