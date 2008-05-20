Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout2.freenet.de ([195.4.92.92])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ruediger.dohmhardt@freenet.de>) id 1JyM5t-0004Bu-86
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 09:17:10 +0200
Message-ID: <48327AEF.1060809@freenet.de>
Date: Tue, 20 May 2008 09:17:03 +0200
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <482EB3E5.7090607@freenet.de> <482F49BB.4060300@gmail.com>
In-Reply-To: <482F49BB.4060300@gmail.com>
Cc: "linux-dvb: linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] CAM of Mantis 2033 still not working
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

Manu Abraham schrieb:
> Ruediger Dohmhardt wrote:
>   
>> Dear Manu,
>>
>> the code from
>>
>> http://jusst.de/hg/mantis (10.5.08)
>>
>> now works fine for the 2033 without the CAM (here Alphacrypt Light)
>> inserted.
>>
>> When I insert the CAM, audio and video stop. I need to remove the CAM
>> and  I must  reload the module with
>>
>>    modprobe -r mantis
>>
>> followed by
>>
>>    modprobe mantis
>>
>> Could you please look into the attached /var/log/messages file.
>> Maybe it could provide a hint, what's still wrong.
>>
>> The verbose level is set to 3 (options mantis verbose=3)
>>     
>
>
> Applied some changes, couldn't test the changes while being away, but
> only build tests. Please do test again, also feel free to play with the
> individual changesets as to check for various stage tests.
>   
Dear Manu,

all changesets from Saturday night did not recognize the CAM.
I could, though, keep the Alphacrypt-Light plugged, but vdr-1.4.7 
provided only TV from the unencrypted channels.
vdr's CAM menu could not access the CAM.

changeset 7325b14e79e460fc (Monday evening):
Unencrypted channels: ok:
When I zap to an encrypted one, the drive hangs as shown below.
Then I need to reboot the machine, because
   
    modprobe -r mantis
 
could not really unload the module.

----------------------------------------------------------------------------------------------------------------------------------------------------

May 20 08:57:08 linux-sh8m kernel: mantis start feed & dma
May 20 08:57:08 linux-sh8m vdr: [5682] KBD remote control thread started 
(pid=5662, tid=5682)
May 20 08:57:08 linux-sh8m vdr: [5683] transfer thread started 
(pid=5662, tid=5683)
May 20 08:57:08 linux-sh8m vdr: [5684] receiver on device 1 thread 
started (pid=5662, tid=5684)
May 20 08:57:08 linux-sh8m vdr: [5686] TS buffer on device 1 thread 
started (pid=5662, tid=5686)
May 20 08:57:08 linux-sh8m vdr: [5683] [xine..put] Detected video size 
720x576
May 20 08:57:09 linux-sh8m vdr: [5683] setting audio track to 1 (0)
May 20 08:57:12 linux-sh8m vdr: [5681] [xine..put] Client 0 connected: 
127.0.0.1:3484
May 20 08:57:12 linux-sh8m vdr: [5681] [xine..put] cxSocket: 
setsockopt(SO_SNDBUF): got 262142 bytes
May 20 08:57:12 linux-sh8m vdr: [5681] [xine..put] Trying PIPE 
connection ...
May 20 08:57:12 linux-sh8m vdr: [5681] creating directory 
/video/plugins/xineliboutput/pipes.5662
May 20 08:57:12 linux-sh8m vdr: [5681] removing 
/video/plugins/xineliboutput/pipes.5662
May 20 08:57:12 linux-sh8m vdr: [5681] [xine..put] cBackgroundWriterI 
initialized (buffer 512 kb)
May 20 08:57:12 linux-sh8m vdr: [5681] [xine..put] cTcpWriter 
initialized (buffer 512 kb)
May 20 08:57:12 linux-sh8m vdr: [5681] [xine..put] Pipe open
May 20 08:57:19 linux-sh8m vdr: [5679] changing pids of channel 58 from 
701+701:702:204 to 901+901:902:204
/*
* switching to encrypted channel
*/
May 20 08:57:39 linux-sh8m vdr: [5678] frontend 0 lost lock on channel 
1, tp 113
May 20 08:57:41 linux-sh8m vdr: [5678] frontend 0 timed out while tuning 
to channel 1, tp 113
May 20 08:58:07 linux-sh8m vdr: [5662] switching to channel 3
May 20 08:58:07 linux-sh8m vdr: [5683] transfer thread ended (pid=5662, 
tid=5683)
May 20 08:58:07 linux-sh8m vdr: [5686] TS buffer on device 1 thread 
ended (pid=5662, tid=5686)
May 20 08:58:07 linux-sh8m vdr: [5684] buffer stats: 113552 (5%) used
May 20 08:58:07 linux-sh8m vdr: [5684] receiver on device 1 thread ended 
(pid=5662, tid=5684)
May 20 08:58:07 linux-sh8m vdr: [5662] cTS2PES got 1 TS errors, 1 TS 
continuity errors
May 20 08:58:07 linux-sh8m vdr: [5662] cTS2PES got 1 TS errors, 1 TS 
continuity errors
May 20 08:58:07 linux-sh8m vdr: [5662] buffer stats: 205484 (9%) used
May 20 08:58:07 linux-sh8m vdr: [5723] transfer thread started 
(pid=5662, tid=5723)
May 20 08:58:07 linux-sh8m vdr: [5724] receiver on device 1 thread 
started (pid=5662, tid=5724)
May 20 08:58:07 linux-sh8m vdr: [5725] TS buffer on device 1 thread 
started (pid=5662, tid=5725)
May 20 08:58:16 linux-sh8m vdr: [5678] frontend 0 timed out while tuning 
to channel 3, tp 121
May 20 08:58:23 linux-sh8m vdr: [5662] switching to channel 2
May 20 08:58:23 linux-sh8m vdr: [5723] transfer thread ended (pid=5662, 
tid=5723)
May 20 08:58:23 linux-sh8m kernel: mantis stop feed and dma
May 20 08:58:23 linux-sh8m vdr: [5725] TS buffer on device 1 thread 
ended (pid=5662, tid=5725)
May 20 08:58:23 linux-sh8m vdr: [5724] buffer stats: 0 (0%) used
May 20 08:58:23 linux-sh8m vdr: [5724] receiver on device 1 thread ended 
(pid=5662, tid=5724)
May 20 08:58:23 linux-sh8m vdr: [5662] buffer stats: 0 (0%) used
May 20 08:58:23 linux-sh8m kernel: mantis start feed & dma
May 20 08:58:23 linux-sh8m vdr: [5726] transfer thread started 
(pid=5662, tid=5726)
May 20 08:58:23 linux-sh8m vdr: [5727] receiver on device 1 thread 
started (pid=5662, tid=5727)
May 20 08:58:23 linux-sh8m vdr: [5728] TS buffer on device 1 thread 
started (pid=5662, tid=5728)
/*
* Switching back to unencrypted channel
*7
May 20 08:58:26 linux-sh8m kernel: mantis_ack_wait (0): Slave RACK Fail !
May 20 08:58:26 linux-sh8m kernel: DVB: TDA10021(0): _tda10021_writereg, 
writereg error (reg == 0x0c, val == 0x1e, ret == -121)
May 20 08:58:28 linux-sh8m kernel: APIC error on CPU0: 40(40)
May 20 08:58:29 linux-sh8m kernel: mantis_ack_wait (0): Slave RACK Fail !
May 20 08:58:29 linux-sh8m kernel: DVB: TDA10021(0): _tda10021_writereg, 
writereg error (reg == 0x0d, val == 0x86, ret == -121)
May 20 08:58:32 linux-sh8m kernel: mantis_ack_wait (0): Slave RACK Fail !
May 20 08:58:32 linux-sh8m kernel: DVB: TDA10021(0): _tda10021_writereg, 
writereg error (reg == 0x0e, val == 0x43, ret == -121)
May 20 08:58:35 linux-sh8m kernel: mantis_ack_wait (0): Slave RACK Fail !
May 20 08:58:35 linux-sh8m kernel: DVB: TDA10021(0): _tda10021_writereg, 
writereg error (reg == 0x34, val == 0x22, ret == -121)
May 20 08:58:38 linux-sh8m kernel: mantis_ack_wait (0): Slave RACK Fail !
May 20 08:58:38 linux-sh8m kernel: DVB: TDA10021(0): _tda10021_writereg, 
writereg error (reg == 0x01, val == 0x6a, ret == -121)
May 20 08:58:41 linux-sh8m kernel: mantis_ack_wait (0): Slave RACK Fail !
May 20 08:58:41 linux-sh8m kernel: DVB: TDA10021(0): _tda10021_writereg, 
writereg error (reg == 0x05, val == 0x46, ret == -121)
May 20 08:58:44 linux-sh8m vdr: [5681] [xine..put] Closing connection 0
May 20 08:58:44 linux-sh8m kernel: mantis_ack_wait (0): Slave RACK Fail !
May 20 08:58:44 linux-sh8m kernel: DVB: TDA10021(0): _tda10021_writereg, 
writereg error (reg == 0x08, val == 0x43, ret == -121)
May 20 08:58:47 linux-sh8m kernel: mantis_ack_wait (0): Slave RACK Fail !
May 20 08:58:47 linux-sh8m kernel: DVB: TDA10021(0): _tda10021_writereg, 
writereg error (reg == 0x09, val == 0x6a, ret == -121)
May 20 08:58:50 linux-sh8m kernel: mantis_ack_wait (0): Slave RACK Fail !
May 20 08:58:50 linux-sh8m kernel: DVB: TDA10021(0): _tda10021_writereg, 
writereg error (reg == 0x00, val == 0x6a, ret == -121)
May 20 08:58:53 linux-sh8m kernel: mantis_ack_wait (0): Slave RACK Fail !
May 20 08:58:53 linux-sh8m kernel: DVB: TDA10021(0): _tda10021_writereg, 
writereg error (reg == 0x00, val == 0x6b, ret == -121)




Ciao Ruediger


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
