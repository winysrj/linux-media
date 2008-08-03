Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m73Kfk9J024254
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 16:41:46 -0400
Received: from ws5-9.us4.outblaze.com (ws5-9.us4.outblaze.com [205.158.62.94])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m73KfUYn031673
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 16:41:31 -0400
Message-ID: <489617F8.7040408@linuxmail.org>
Date: Sun, 03 Aug 2008 15:41:28 -0500
From: Perry Gilfillan <perrye@linuxmail.org>
MIME-Version: 1.0
To: v4l <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Howto select one of 16 inputs on Digi-Flower boards?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I've recently laid hands on a few Digi-Flower capture cards and 
found no indication that anyone has ever taken the time to poke at 
these cards with a digital multi-meter to discover how they are laid 
out.

I have two versions, the DVR2000B-R02, and the DVR2510-MP2.  The 
DVR2000B has four Fusion 878A decoders, while the DVR2510 has two. 
I'm going to concentrate on the DVR2000B since the second should for 
the most part be identical.

They both can support 16 composite inputs that are multiplexed 
through pairs of 74HC4051A Analog Multiplexer/Demutiplexers.  Which 
of the 16 inputs is routed to any of the four 878A's is controlled 
by GPIO pins.

Each 878A device controls a pair of M/D'ers:

       GPIO[0,1,2] => M/D[1][A,B,C] (select pins)
       GPIO[18]    => M/D[1][Enable]

       GPIO[0,1,2] => M/D[2][A,B,C] (select pins)
       GPIO[20]    => M/D[2][Enable]

When an input has been routed the signal is split between the 878A's 
MUX0 and a 4581CS Sync Separator.  As far as I can tell the only 
output of the 4581CS that is used is the Odd/Even field output that 
is routed to GPIO[15] on the respective 878A


                       74HC4051A
Comp-In (1-8)  => M/D[1] (X0-7) -> (Output) \   [ L/C/R ](inductor/
                                              |= [network] capacitor/
Comp-In (9-16) => M/D[2] (X0-7) -> (Output) /             resistor)

                4581CS Sync Separator
    L/C/R     /  Comp-In -> Odd/Even  => GPIO[15]
  [network] =|
              \ 878A: MUX0

I think this pretty much describes what would be needed to implement 
these cards, but the actual doing begins to exceed my limited 
abilities.  If those of you that are familiar with the 150 some odd 
cards that do work, and which of them might be similar in 
implementation to these cards, and can point out the relevant parts, 
I'll have a go at it.

There is also a fifth pair of Mux/Demux chips that are used to send 
one of 16 inputs to an RCA jack via a 6db video amp.  This routing 
function is controlled by an Atmel AT89C2051 (8051 family) micro 
controller.  I have not determined how to talk to the micro 
controller at this time.

There is also a set of 8 external device I/O ports to send or 
receive On/Off signals from motion detectors or drive alarm 
circuits, and an on board WatchDog relay output.  These are 
controlled by GPIO[3-10,12-13] of the first 878A.  More details later.

More information on the Digi-Flower DVR2000B (DVR2510 is not listed 
here) cards made by Anko: http://www.anko-tech.com/products/df2000.htm


lspci data for the DVR2000B ( these numbers seem very generic.. how 
can the specific card be known?)

02:00.0 PCI bridge [0604]: Hint Corp HB6 Universal PCI-PCI bridge 
(non-transparent mode) [3388:0021] (rev 11)
03:0c.0 Multimedia video controller [0400]: Brooktree Corporation 
Bt878 Video Capture [109e:036e] (rev 11)
03:0c.1 Multimedia controller [0480]: Brooktree Corporation Bt878 
Audio Capture [109e:0878] (rev 11)
03:0d.0 Multimedia video controller [0400]: Brooktree Corporation 
Bt878 Video Capture [109e:036e] (rev 11)
03:0d.1 Multimedia controller [0480]: Brooktree Corporation Bt878 
Audio Capture [109e:0878] (rev 11)
03:0e.0 Multimedia video controller [0400]: Brooktree Corporation 
Bt878 Video Capture [109e:036e] (rev 11)
03:0e.1 Multimedia controller [0480]: Brooktree Corporation Bt878 
Audio Capture [109e:0878] (rev 11)
03:0f.0 Multimedia video controller [0400]: Brooktree Corporation 
Bt878 Video Capture [109e:036e] (rev 11)
03:0f.1 Multimedia controller [0480]: Brooktree Corporation Bt878 
Audio Capture [109e:0878] (rev 11)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
