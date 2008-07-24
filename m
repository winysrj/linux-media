Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6OJJr7o006996
	for <video4linux-list@redhat.com>; Thu, 24 Jul 2008 15:19:53 -0400
Received: from nlpi025.prodigy.net (nlpi025.sbcis.sbc.com [207.115.36.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6OJJGTN003633
	for <video4linux-list@redhat.com>; Thu, 24 Jul 2008 15:19:16 -0400
Message-ID: <4888D5A7.8090900@xnet.com>
Date: Thu, 24 Jul 2008 14:19:03 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <487F495A.10806@xnet.com> <488120FF.2030402@xnet.com>
In-Reply-To: <488120FF.2030402@xnet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: Kworld 120 tuner - what should I expect?
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



stuart wrote:
> 
> 
> stuart wrote:
>>
>> Hi...
>>
>> I just installed a Kworld 120 (the successor to the Kworld 115 & 110 
>> ATSC tuners) into a Debian mythtv box.  I am using a recent (several 
>> days old) version of v4l (pulled using Hg).
>>
>> Things appear to be running, however I still can not tune in any ATSC 
>> stations (another mythtv box split off the same antenna is receiving 
>> over a dozen ATSC stations).  I have not even tried to get the Kworld 
>> 120 NTSC tuner working.
>>
>> As Kworld 120 support is new, I was wondering what to expect. There 
>> have been threads pointing out this new and very different version of 
>> Kworld tuners has to be rebooted in order to switch between tuning 
>> ATSC and NTSC signals.  I wonder if that is still true.  And, if 
>> anything, what else I should expect.
>>
>> Also, what are the best tools to configure & test this type of 
>> hardware and how do you use them?  Running through mythtv-setup every 
>> iteration does take time.
>>
>> ...thanks
>>
> 
> I know working off of "v4l dvb staging" is risky business, but I'm 
> trying to get the new Kworld 120 tuner (replacement for the old Kworld 
> 115 and older yet Kworld 110 tuner) to work.
> 
> I'm running a scan (which I assume is the old scandvb?? which I can't 
> find anymore) on both of my mythtv Debian boxes.  My master back end has 
> a Kworld 110 and my newer slave front end has a Kworld 120 card.  I'm 
> only running "v4l dvb staging" on the newer slave front end.
> 
> The scan output on the master back end shows 33 services.  While the 
> scan output on the new slave front end shows 0 services.  I should next 
> check the antenna hook up on the slave front end - but, if anything, it 
> should be a good +3dB better then the slave back end (having one less 
> splitter).
> 
> I would appreciate hearing from anyone who has had success with the 
> Kworld 120 in a mythtv box.
> 
> ...thanks.
> 

With the help of people involved with the video4linux project I've 
gotten to the point where my Kworld 120 tuner properly scans for ATSC 
signals.  So, I've made a first pass at populating the Kworld 120 wiki 
with the steps which I took as well as some extra suggestions people 
have made.  Emphasis on the "first pass", as I have some cleaning up to 
do.  If you are in dire need of instructions you can have a look.  Of 
course you'll be obliged to offer feedback either here or by editing my 
scribbles on the wiki ;-) :

> http://www.linuxtv.org/wiki/index.php/KWorld_ATSC_120

...thanks.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
