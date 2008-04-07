Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n4.bullet.ukl.yahoo.com ([217.146.182.181])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <r.schedel@yahoo.de>) id 1Jinhd-0004LH-B1
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 11:31:51 +0200
Message-ID: <47F9E95D.6070705@yahoo.de>
Date: Mon, 07 Apr 2008 11:29:01 +0200
From: Robert Schedel <r.schedel@yahoo.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] High CPU load in "top" due to budget_av slot polling
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

Hello,

on 2.6.24 I run into a small issue with the budget_av driver:

Hardware: Athlon 64X2 3800+, Satelco Easywatch DVB-C (1894:002c), no CI/CAM
Software: Linux kernel 2.6.24 (gentoo-r4) SMP x86_64, budget_av module

Error description:
After the budget_av driver module is loaded (even without any DVB 
application), the CPU load average in 'top' rises to ~1, but in top no 
active tasks are found. After unloading the driver, the load decreases 
again to ~0.

Displaying the blocked tasks during high load with Alt-SysRq-W shows 
that the kdvb-ca kernel thread seems to be accounted as blocked when it 
polls for the CI slot status:
---------------------------------------------------
SysRq : Show Blocked State
task                        PC stack   pid father
kdvb-ca-0:0   D 0000000100d78984     0  2046      2
ffff81007ee73c70 0000000000000046 0000000000000000 0000000000000008
0000000000000800 0000000000000000 0000000000000286 ffff81007bebe080
ffff81007f8d47e0 ffff81007ee73c80 ffff81007ed91a00 0000000100d78984
Call Trace:
[<ffffffff80241da6>] __mod_timer+0xb6/0xd0
[<ffffffff804e52ff>] schedule_timeout+0x5f/0xd0
[<ffffffff80241890>] process_timeout+0x0/0x10
[<ffffffff80241dd6>] msleep+0x16/0x30
[<ffffffff880a0189>] :saa7146:saa7146_wait_for_debi_done+0x159/0x260
[<ffffffff880bba3a>] :budget_core:ttpci_budget_debiread+0x6a/0x140
[<ffffffff880d1cfb>] :budget_av:ciintf_poll_slot_status+0xbb/0x1c0
[<ffffffff880aa800>] :dvb_core:dvb_ca_en50221_thread+0x0/0xa10
[<ffffffff880a9339>] :dvb_core:dvb_ca_en50221_check_camstatus+0x59/0x100
[<ffffffff880aa8ba>] :dvb_core:dvb_ca_en50221_thread+0xba/0xa10
[<ffffffff8022f221>] update_curr+0x61/0xb0
[<ffffffff8022f221>] update_curr+0x61/0xb0
[<ffffffff802341e6>] dequeue_task_fair+0x46/0x80
[<ffffffff8022f79d>] __dequeue_entity+0x3d/0x50
[<ffffffff804e4a7e>] thread_return+0x3d/0x52f
[<ffffffff80288da4>] filp_close+0x54/0x90
[<ffffffff880aa800>] :dvb_core:dvb_ca_en50221_thread+0x0/0xa10
[<ffffffff8024d48b>] kthread+0x4b/0x80
[<ffffffff8020ca48>] child_rip+0xa/0x12
[<ffffffff8024d440>] kthread+0x0/0x80
[<ffffffff8020ca3e>] child_rip+0x0/0x12
---------------------------------------------------

Enabling debug traces shows that polling for the PSR in function 
'saa7146_wait_for_debi_done_sleep' constantly times out after 250x1ms 
sleeps:

 > saa7146: saa7146_wait_for_debi_done_sleep(): saa7146 (0): 
saa7146_wait_for_debi_done_sleep timed out while waiting for transfer 
completion

Increasing the 250ms did not avoid the timeout. And as I understood from 
previous list mails, this timeout is normal when no CI/CAM is connected 
to the DEBI. However, for me the high frequency polling does not make 
sense if someone does not plan to plug in a CI/CAM.

When commenting out two lines in 'dvb_ca_en50221_thread_update_delay' to 
increase the polling timer for slotstate NONE from 100ms (!) to 60s, the 
CPU load went down to 0. So this is some kind of workaround for me.

Please note: The high CPU load is not only a statistical issue due to 
the kernel accounting. It would put at least some unnecessary stress on 
PCI and CPU and e.g. also has the effect that cron tasks with idle guard 
condition would not start, so on midterm this should be fixed.

Finally, my questions:
1. Did I understand this right, that the behaviour above is expected 
when no CI is connected?

2. Are all budget_av cards unable to check CAM slot state via interrupt 
  for HW reasons (as budget_ci does)?

3. Would it be possible to substitute the current PSR DEBI_S polling 
with an interrupt based solution via IER/ISR? (driver av7110 alreadys 
seems to do this for its DEBI DMA)? Or was this not considered worthy, 
due to the expected short waiting period and the tricky IER handling? 
The code does not state further thoughts about this.

4. Are the high timeout periods in debi_done (50ms/250ms) in relation to 
the 100ms poll timer intended? (I found the recent patch to this code in 
the mailing list end of last year)

5. If we would be restricted to poll with high frequency: Why not at 
least allow users without CI to disable polling for slots or change the 
interval, e.g. via module options?

Regards,
Robert Schedel


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
