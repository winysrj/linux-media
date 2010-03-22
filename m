Return-path: <linux-media-owner@vger.kernel.org>
Received: from www49.your-server.de ([213.133.104.49]:48879 "EHLO
	www49.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab0CVRmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 13:42:38 -0400
Received: from [188.107.127.143] (helo=[192.168.1.32])
	by www49.your-server.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <repplinger@motama.com>)
	id 1Ntle9-0007w1-0W
	for linux-media@vger.kernel.org; Mon, 22 Mar 2010 18:42:37 +0100
Message-ID: <4BA7ABF1.7010009@motama.com>
Date: Mon, 22 Mar 2010 18:42:09 +0100
From: Michael Repplinger <repplinger@motama.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Questions to ngene/dvb_frontend driver [Original email was "Problems
 with ngene based DVB cards (Digital Devices Cine S2 Dual DVB-S2 , Mystique
 SaTiX S2 Dual)"]
References: <4BA73D83.1010002@motama.com>
In-Reply-To: <4BA73D83.1010002@motama.com>
Content-Type: multipart/mixed;
 boundary="------------050105060302080008060801"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050105060302080008060801
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi list,

in addition to my previous tests, I found that the problems with long
tuning delays only occurs when switching to an SD channel.  If I switch
to an HD channel, e.g., using adapter 0, I always get fast tuning times
(see my tests below).

Since the large delays only occur when switching to an SD channel, I
have the following questions.

1) Is there different code for tuning to an HD channel or tuning to an
SD-channel?

2) If yes, which which methods in which modules are repsonsible for
tuning to an SD/HD channel?

3) Are there any methods wihtin the dvb_frontend oder ngene Modul (or
anywhere in the DVB driver) that have to differ between  SD- and HD
channels?

It would be realy great, if somone can answer these questions or give me
some hints to find the problem.

Best regards
  Michael


Tests (channels_DVB-S2_transponder_switch_HD.conf and
channels_DVB-S2_transponder_switch.conf are attached to this email):
1) Tune to a TV channel and forward data to dvr device
./szap-s2 -S 1 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -r

2) In paralle to1) use adapter 0 to tune to an HD-Kanal
./szap-s2 -H -c channels_DVB-S2_transponder_switch_HD.conf -a 0 -n 2 -x
-S 1 | grep Delay
Delay : 0.569672

3) In paralle to1) use adapter 0 to tune to an HD-Kanal
./szap-s2 -H -c channels_DVB-S2_transponder_switch_HD.conf -a 0 -n 1 -x
-S 1 | grep Delay
Delay : 0.581712

4) In paralle to1) use adapter 0 to tune to an SD-Kanal
./szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 0 -n 1 -x |
grep Delay
Delay : 1.760880

Michael Repplinger wrote:
> Hi,
> I read the problems described in email thread "Problems with ngene based
> DVB cards (Digital Devices Cine S2 Dual DVB-S2 , Mystique SaTiX S2
> Dual)". Unfortunately, I just subscribed to this list so I cannot
> respond to the original mail directly but it can be found at the end of
> this mail.
>
> For tracking down the described problems with high delays, I tried to
> understand the dvb_frontend and ngene driver and added some output
> messages. The added output messages are attached as a ptach to this
> email. Since this was the first time I read the source code of the
> module I was not able to find a real problem or bug.
>
> However, I found 3 issues that I would like to report. Especially issue
> 1) could be a problem. Here the irq handler of ngene module is still
> triggered for 60secs if the last application using the DVB devices
> terminates.
> In Issue 2) I describe the methods that need more time when the
> described problem occur. Unfortunately, I could only determine that
> these methods need more time but was not able to find a reason.
> Issue 3) could be related to issue 1). Here I saw that the ngene module
> is not informed if the DVB frontend device is closed.
>
> Again, since I read the source code of a driver for the first time I
> don't know if the described issues are OK or not. It would be great if
> some of you could check the described issues. Maybe this information
> helps to find/solve the problem.
>
> Thanks in advance
>   Michael Repplinger
>
> Testsystem:
> -Kernel: 2.6.25.20-0.5-pae (Suse 11.0 distribution)
> -Driver: following endriss/ngene DVB driver + attached patch
>   *Repository URL : http://linuxtv.org/hg/~endriss/ngene
>   *Revision       : 14413:510e37da759e
>
> *Issue 1) IRQ handler is triggered  for 60 seconds after last
> application stops using the dvb device:*
>
> Reproduce Test:
> a) load dvb modules as follows:
>   rmmod ngene
>   rmmod dvb_core
>
>   modprobe dvb_core dvbdev_debug=1 frontend_debug=1 debug=1 cam_debug=1
> dvb_demux_tscheck=1 dvb_net_debug=1 
>   modprobe ngene debug=1 one_adapter=0
>
> b) tail -f /var/log/messages
> c) In parallel to b) start
>    ./szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 0 -n 1 -x
>
> *Observation 1: *
> In b) one can see the following output messages:
> Mar 20 14:18:01 dvb_host kernel: ngene>: irq_handler IRQ 16
> Mar 20 14:18:01 dvb_host kernel: ngene< : irq_handler return IRQ_HANDLED
> Mar 20 14:18:01 dvb_host kernel: ngene: demux_tasklet
> Mar 20 14:18:01 dvb_host kernel: ngene: tsin_exchange
>
> => The following mehtods of ngene-core.c are called
> - static irqreturn_t irq_handler(int irq, void *dev_id) ( produces the
> first two lines of the above output messages)
> - static void demux_tasklet(unsigned long data) ( produces the third
> lines of the above output messages)
> - static void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock,
> u32 flags) (procudes the last output message)
>
> => IRQ handler of ngene-core module is periodically triggered as soon as the
> first application using DVB device has been used
>
> *Observation 2: *
> Exactly 60 seconds after executing c), the IRQ handler is no longer
> triggered
> and no more output messages appear in b).
> Here the last output messages are:
>
> Mar 20 14:19:01 dvb_host kernel: ngene< : irq_handler return IRQ_HANDLED
> Mar 20 14:19:01 dvb_host kernel: ngene: demux_tasklet
> Mar 20 14:19:01 dvb_host kernel: ngene: tsin_exchange
> Mar 20 14:19:01 dvb_host kernel: ngene: ngene_i2c_master_xfer
> Mar 20 14:19:01 dvb_host kernel: ngene: > ngene_i2x_set_bus
> Mar 20 14:19:01 dvb_host kernel: ngene: ngene_i2c_set_bus
> Mar 20 14:19:01 dvb_host kernel: ngene: < ngene_i2x_set_bus
> Mar 20 14:19:01 dvb_host kernel: ngene: num = 1 ngene_command_i2c_write
> Mar 20 14:19:01 dvb_host kernel: ngene: ngene_command_i2c_write
> Mar 20 14:19:01 dvb_host kernel: ngene: ngene_command
> Mar 20 14:19:01 dvb_host kernel: ngene: ngene_command_mutex
> Mar 20 14:19:01 dvb_host kernel: ngene>: irq_handler IRQ 16
> Mar 20 14:19:01 dvb_host kernel: ngene< : irq_handler return IRQ_HANDLED
> Mar 20 14:19:01 dvb_host kernel: ngene>: irq_handler IRQ 16
> Mar 20 14:19:01 dvb_host kernel: ngene< : irq_handler return IRQ_HANDLED
> Mar 20 14:19:01 dvb_host kernel: ngene: ngene_i2c_master_xfer  succeeded
>
> => In this case, the mehtod ngene_i2c_master_xfer is invoked and
> successfully processed (additional invoked methods can also be seen from
> the output).
>
> *Conclusion: *
> Since I dont understand whats going on here, I don't know if this is
> correct or could cause problems. However, I would expect that the IRQ
> handler is not triggered, if no application accesses the DVB device.
> Moreover, after 60 seconds the IRQ trigger is no longer triggered. This
> looks like the kernel (or any other module) stops the ngene-module.
>
>
>
> *Issue 2) High delay ~(1.7-18 seconds) when switching the channel *
> By enabling and adding additional output messages in used dvb modules, I was
> able to find the mehtod that causes a higher delay.
>
>
> Reproduce Test:
> a) load dvb modules as follows:
>   rmmod ngene
>   rmmod dvb_core
>
>   modprobe dvb_core dvbdev_debug=1 frontend_debug=1 debug=1 cam_debug=1
> dvb_demux_tscheck=1 dvb_net_debug=1 
>   modprobe ngene debug=1 one_adapter=0
>
> b) tail -f /var/log/messages
>
> c)./run_szap-s2_adapter0.sh | grep Delay
>
> d) in parallel to c)
> szap-s2 -S 1 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -r
>
> => while d) is running c) will show increased tuning times
>
> *Observations: *
> In b) one can see the following output
> Mar 20 11:15:23 dvb_host kernel: dvb_frontend_thread: Frontend ALGO =
> DVBFE_ALGO_CUSTOM, state=2
> Mar 20 11:15:23 dvb_host kernel: dvb_frontend_thread: Retune requested,
> FESTAT_RETUNE
> Mar 20 11:15:23 dvb_host kernel: >search, status
> Mar 20 11:15:23 dvb_host kernel: dvb_frontend_ioctl (69)
> <Delay>
> Mar 20 09:32:25 dvb_host kernel: <search, status
> Mar 20 11:15:25 dvb_host kernel: dvb_frontend_add_event
>
>
> => Excecuting dvb_frontend_ioctl 69 needs more time to be executed. The
> reason for this is that the exectuing the ioctl requires locking an
> internal mutex. This mutex is still locked by method dvb_frontend_thread
> due to tuning the channel. In more detail, method dvb_frontend_thread
> handles the case DVBFE_ALGO_CUSTOM: which performs a customized tuning
> method. The corresponding
> search operation looks as follows.
>   dprintk(">search, status\n");                                     
>       /* We did do a search as was requested, the flags are
>         * now unset as well and has the flags wrt to search.
>         */
>       fepriv->algo_status = fe->ops.search(fe,
> &fepriv->parameters);           
>   dprintk("<search, status\n");                                     
>
> The method invocation fe->ops.search triggers method
> ngene_i2c_master_xfer in ngene-core.c several times. The amount of
> invoking method ngene_i2c_master_xfer is equal when you have good or bad
> tuning delays.
>
> *Conclusion:  *
> The only conclusion I can get from this test is that the tuning mehtod
> itself needs more time. Thats what we already know. Unfortunately, I was
> not able to find a reason why executing the involved methods for tuning
> need more time.
>
>
> *Issue 3) Is opending/closing the frontend device in dvb_frontend/ngene
> module OK?. *
> Actually, I dont know if these methods are correctly implemented, The
> corresponding mehtods in dvb_frontend.c are:
>
> static int dvb_frontend_open(struct inode *inode, struct file *file)
> static int dvb_frontend_release(struct inode *inode, struct file *file)
>
> In method dvb_frontend_release, I added some output message to see if the
> clenaup operations in all if-statemements are executeed.
>
>       if (fepriv->exit == 1) {
>               dprintk (" >Internal cleanup when closin DVB device 
> %s\n", __func__);      
>               fops_put(file->f_op);
>               file->f_op = NULL;
>               wake_up(&dvbdev->wait_queue);
>               dprintk (" <Internal cleanup when closin DVB device 
> %s\n", __func__);      
>       }
>       if (fe->ops.ts_bus_ctrl) {
>               dprintk (" >Invoke fe->ops.ts_bus_ctrl  %s\n",
> __func__);      
>               fe->ops.ts_bus_ctrl(fe, 0);
>               dprintk (" >Invoke fe->ops.ts_bus_ctrl %s\n",
> __func__);         
>       }                    
>
> Reproduce Test:
> a) load dvb modules as follows:
>   rmmod ngene
>   rmmod dvb_core
>
>   modprobe dvb_core dvbdev_debug=1 frontend_debug=1 debug=1 cam_debug=1
> dvb_demux_tscheck=1 dvb_net_debug=1 
>   modprobe ngene debug=1 one_adapter=0
>
> b) tail -f /var/log/messages | grep -v ngene
>
> c) ./szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -x
>
> Observation:
> In b) the following output appears adedd output messages appear
> ...
> Mar 20 15:17:30 dvb_host kernel:  <down interruptable dvb_frontend_ioctl
> (73)
> Mar 20 15:17:30 dvb_host kernel:  dvb_frontend_ioctl_legacy
> dvb_frontend_ioctl (73)
> Mar 20 15:17:30 dvb_host kernel: > up dvb_frontend_ioctl (73)
> Mar 20 15:17:30 dvb_host kernel: <up dvb_frontend_ioctl (73)
> Mar 20 15:17:30 dvb_host kernel: dvb_frontend_release
>
> The added output messages do not appear. =>Not all cleanup functions are
> called. However, even after reading the code I don't know if this is
> correct or not. These if-statements seem to be executed only if the
> frontend-thread is stopped (which happens if the module is unloaded). So
> I think this is OK.
>
> However, no additional mehtod on the ngene-core module is called. If you
> use the following command in b)
>   tail -f /var/log/messages
> then you receive only the messages described in issue 1), observation
> 1). If you outcomment the corresponding output messages in ngene-core.c,
> no additional output message appears from ngene module.
>
>
> *Conclusion: *
> I think that there is no general problem with opening/closing methods
> implemented in dvb-frontend.c. The only problem I could see is that the
> ngene module is not informed about this. From my point of view I found
> only one reason to inform the ngene module about such an event which is
> to unregister the IRQ handler (see issue 1). Since I have no real
> knlowedge about driver development, I don't know if this is correct or not.
>
>
> On Thu, Mar 18, 2010 at 11:07 AM, Marco *Lohse* <m*lohse* <at>
> motama.com> wrote:
>   
>> Devin Heitmueller wrote:
>>     
>>> On Thu, Mar 18, 2010 at 6:00 AM, Andreas Besse <besse <at>
>>>       
> motama.com> wrote:
>   
>>>> Hello,
>>>>
>>>> We are now able to reproduce the problem faster and easier (using the
>>>> patched version of szap-s2 and the scripts included in the tar.gz :
>>>>
>>>>         
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/17334
>   
>>>> and
>>>>
>>>>         
> http://cache.gmane.org//gmane/linux/drivers/video-input-infrastructure/17334-001.bin
>   
>>>> )
>>>>         
>>> This is pretty interesting.  I'm doing some ngene work over the next
>>> few weeks, so I will see if I can reproduce the behavior you are
>>> seeing here.
>>>
>>> I noticed  that you are manually setting the "one_adapter=0" modprobe
>>> setting.  Does this have any bearing on the test results?
>>>
>>>       
>> I will try to answer this one:
>>
>> No, leaving out this parameter does not change the test results; you
>> will only need to use different and additional parameters for szap-s2
>> for specifying the correct adapter and sub-devices.
>>
>> By now, we also found out that the problems can be reproduced much easier:
>>
>> 0)
>>
>> szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 0 -n 1 -x |
>> grep Delay
>>
>> Delay : 0.573021
>>
>> 1)
>>
>> szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -x |
>> grep Delay
>> Delay : 0.564667
>>
>> 2)
>>
>> szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 0 -n 1 -x |
>> grep Delay
>> Delay : 1.741931
>>
>> Instead of 2) you can also run the included script
>>
>> 2')
>>
>> ./run_szap-s2_adapter0.sh
>>
>> which will result in the device timeout after 30-40 iterations
>>
>> To summarize
>>
>> => When opening and closing adapter0, then opening and closing devices
>> of adapter1, this will immediately result in problems.
>>
>> And there a lot more variations of this bug, for example: actually read
>> data from adapter0, tune adapter1 using szap-s2, which will result in
>> adapter0 to be 'blocked' and not produce any more data after around 60
>>     
> secs.
>   
>> We are currently trying to dig into the source code of the driver to
>> solve the problems and would appreciate any help.
>>     
>
>
>
>   



--------------050105060302080008060801
Content-Type: text/plain;
 name="channels_DVB-S2_transponder_switch_HD.conf"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="channels_DVB-S2_transponder_switch_HD.conf"

ANIXE HD:10832:h:S19.2E:22000:767:771:0:0:61202:0:0:0
Das Erste HD:11361:h:0:22000:6010:6020,6021,6022:0:0:11100

--------------050105060302080008060801
Content-Type: text/plain;
 name="channels_DVB-S2_transponder_switch.conf"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="channels_DVB-S2_transponder_switch.conf"

Das Erste:11836:h:S19.2E:27500:101:102,103;106:104:0:28106:0:0:0
ZDF:11953:h:S19.2E:27500:110:120,121;125:130:0:28006:0:0:0
Bayerisches FS Süd:11836:h:S19.2E:27500:201:202,203;206:204:0:28107:0:0:0
ProSieben:12544:h:S19.2E:22000:511:512;515:33:0:17501:0:0:0
RTL Television:12187:h:S19.2E:27500:163:104;106:105:0:12003:0:0:0

--------------050105060302080008060801--
