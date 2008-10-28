Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pierre.gronlier@gmail.com>) id 1KuoGi-0000QP-IV
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 14:05:57 +0100
Received: by fg-out-1718.google.com with SMTP id e21so2315181fga.25
	for <linux-dvb@linuxtv.org>; Tue, 28 Oct 2008 06:05:53 -0700 (PDT)
Message-ID: <ecc945da0810280605n7608617dla7a9673f38853583@mail.gmail.com>
Date: Tue, 28 Oct 2008 14:05:52 +0100
From: "pierre gronlier" <ticapix@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] cx24116 and FE_DISEQC_SEND_MASTER_CMD
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
I just bought a hvr4000 dvb-s card. I have a dish with a quattro
monobloc lnb head. The first head is pointing towards Astra-19.2E and
the second one towards Hotbird-13.0E. There is no motor.

I'm using a 2.6.26 kernel with the v4l-dvb (mercurial) driver.

I can scan Astra with this command
scan -s 0 /usr/share/dvb/dvb-s/Astra-19.2E
and Hotbird with
scan -s 1 /usr/share/dvb/dvb-s/Hotbird-13.0E

In order to test it quickly, I tried kaffeine and with success I
manage to watch an astra channel, a hotbird channel - and even a
dvb-s2 channel with the dvb-s2 patch from hf.

Then I tried to use dvbstream.
The streaming of a astra channel is working. I tried the same thing
with a hotbirt channel, but my option -D 1 to set the correct lnb head
isn't working.

I took a look in the kaffeine-svn code (svn rev-876871) in the
dvbstream.cpp file I have this:
multimedia/kaffeine/src/input/dvb/dvbstream.cpp:544
    544 #define DISEQC_X 2
    545 int DvbStream::setDiseqc( int switchPos, ChannelDesc *chan,
int hiband, int &rotor, bool dvr )
    546 {
    547         struct dvb_diseqc_master_cmd switchCmd[] = {
    548                 { { 0xe0, 0x10, 0x38, 0xf0, 0x00, 0x00 }, 4 },
    549                 { { 0xe0, 0x10, 0x38, 0xf2, 0x00, 0x00 }, 4 },
    550                 { { 0xe0, 0x10, 0x38, 0xf1, 0x00, 0x00 }, 4 },
    551                 { { 0xe0, 0x10, 0x38, 0xf3, 0x00, 0x00 }, 4 },
    552                 { { 0xe0, 0x10, 0x38, 0xf4, 0x00, 0x00 }, 4 },
    553                 { { 0xe0, 0x10, 0x38, 0xf6, 0x00, 0x00 }, 4 },
    554                 { { 0xe0, 0x10, 0x38, 0xf5, 0x00, 0x00 }, 4 },
    555                 { { 0xe0, 0x10, 0x38, 0xf7, 0x00, 0x00 }, 4 },
    556                 { { 0xe0, 0x10, 0x38, 0xf8, 0x00, 0x00 }, 4 },
    557                 { { 0xe0, 0x10, 0x38, 0xfa, 0x00, 0x00 }, 4 },
    558                 { { 0xe0, 0x10, 0x38, 0xf9, 0x00, 0x00 }, 4 },
    559                 { { 0xe0, 0x10, 0x38, 0xfb, 0x00, 0x00 }, 4 },
    560                 { { 0xe0, 0x10, 0x38, 0xfc, 0x00, 0x00 }, 4 },
    561                 { { 0xe0, 0x10, 0x38, 0xfe, 0x00, 0x00 }, 4 },
    562                 { { 0xe0, 0x10, 0x38, 0xfd, 0x00, 0x00 }, 4 },
    563                 { { 0xe0, 0x10, 0x38, 0xff, 0x00, 0x00 }, 4 },
    564         };
    565
    566         int i;
    567         int voltage18 = ( (chan->tp.pol=='H')||(chan->tp.pol=='h') );
    568         int ci = 4 * switchPos + 2 * hiband + (voltage18 ? 1 : 0);
    569
    570         fprintf( stderr, "DiSEqC: switch pos %i, %sV, %sband
(index %d)\n", switchPos, voltage18 ? "18" : "13", hiband ? "hi" :
"lo", ci );
    571         if ( ci < 0 || ci >=
(int)(sizeof(switchCmd)/sizeof(struct dvb_diseqc_master_cmd)) )
    572                 return -EINVAL;
    573
    574         if ( ioctl(fdFrontend, FE_SET_TONE, SEC_TONE_OFF) )
    575                 perror("FE_SET_TONE failed");
    576         usleep(15*1000);
    577         if ( ioctl(fdFrontend, FE_SET_VOLTAGE, ci%2 ?
SEC_VOLTAGE_18 : SEC_VOLTAGE_13) )
    578                 perror("FE_SET_VOLTAGE failed");
    579
    580         fprintf( stderr, "DiSEqC: %02x %02x %02x %02x %02x
%02x\n", switchCmd[ci].msg[0], switchCmd[ci].msg[1],
switchCmd[ci].msg[2], switchCmd[ci].msg[3], switchCmd[ci].msg[4],
switchCmd[ci].msg[5] );
    581         for ( i=0; i<DISEQC_X; ++i ) {
    582                 usleep(15*1000);
    583                 if ( ioctl(fdFrontend,
FE_DISEQC_SEND_MASTER_CMD, &switchCmd[ci]) )
    584                         perror("FE_DISEQC_SEND_MASTER_CMD failed");
    585         }

Then in the dvbstream-cvs project file tune.c:56

     56 static int diseqc_send_msg(int fd, fe_sec_voltage_t v, struct
diseqc_cmd *cmd,
     57                      fe_sec_tone_mode_t t, unsigned char sat_no)
     58 {
     59    if(ioctl(fd, FE_SET_TONE, SEC_TONE_OFF) < 0)
     60         return -1;
     61    if(ioctl(fd, FE_SET_VOLTAGE, v) < 0)
     62         return -1;
     63    usleep(15 * 1000);
     64    if(sat_no >= 1 && sat_no <= 4)       //1.x compatible equipment
     65    {
     66         fprintf( stderr, "DiSEqC: %02x %02x %02x %02x %02x
%02x\n", &cmd->cmd.msg[0], &cmd->cmd.msg[1], &cmd->cmd.msg[2],
&cmd->cmd.msg[3], &
     66 cmd->cmd.msg[4], &cmd->cmd.msg[5] );
     67
     68     fprintf(stderr, "DEBUG %d\n", sat_no);
     69     if(ioctl(fd, FE_DISEQC_SEND_MASTER_CMD, &cmd->cmd) < 0)
     70         return -1;
     71     usleep(cmd->wait * 1000);
     72     usleep(15 * 1000);
     73    }

	
	 The main diff is that the FE_DISEQC_SEND_MASTER_CMD ioctl call is
made twince in kaffeine.
	
	 So I made some changes in tune.c:
	
	 diff -u -r1.26 tune.c
--- tune.c      25 Sep 2007 21:49:10 -0000      1.26
+++ tune.c      28 Oct 2008 11:01:56 -0000
@@ -63,6 +63,12 @@
    usleep(15 * 1000);
    if(sat_no >= 1 && sat_no <= 4)      //1.x compatible equipment
    {
+    fprintf(stderr, "DEBUG %d\n", sat_no);
+    if(ioctl(fd, FE_DISEQC_SEND_MASTER_CMD, &cmd->cmd) < 0)
+       return -1;
+    usleep(15 * 1000);
     if(ioctl(fd, FE_DISEQC_SEND_MASTER_CMD, &cmd->cmd) < 0)
        return -1;
     usleep(cmd->wait * 1000);

And now dvbstream is working fine with streaming hotbird channels.

Is that normal to have to repeat the command twince ?

Seems to me like a timing problem.

-- 
pierre

-- 
Pierre Gronlier

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
