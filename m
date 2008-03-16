Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jon.the.wise.gdrive@gmail.com>) id 1Jasin-0004ep-LU
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 14:16:18 +0100
Received: by fg-out-1718.google.com with SMTP id 22so3873500fge.25
	for <linux-dvb@linuxtv.org>; Sun, 16 Mar 2008 06:16:14 -0700 (PDT)
Mime-Version: 1.0 (Apple Message framework v753)
In-Reply-To: <7506F33A-1475-4D05-9562-885CAEA8C463@gmail.com>
References: <7506F33A-1475-4D05-9562-885CAEA8C463@gmail.com>
Message-Id: <67E2C7B4-2D3D-43C6-ADC7-A53420DA5014@gmail.com>
From: Jon <jon.the.wise.gdrive@gmail.com>
Date: Sun, 16 Mar 2008 06:16:03 -0700
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle HDTV PCI issues
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


On Mar 16, 2008, at 3:40 AM, Jon wrote:

> Hello,
>
> I have a problem with my capture device.
>
> First a little history. I'm running a openSUSE 10.3 system with  
> mythtv and have had a frame-grabber (bt878) in it until recently. I  
> just upgraded to a pair of pinnacle HDTV pci cards. I just  
> downloaded the source and compiled it this afternoon, following the  
> instructions on the wiki. I have a large antenna on the roof, and I  
> get channels 3, 6, 10, 13, 31, 40 and 58 all clearly with SD.
>
> So, the problem is, I am trying to scan for HD channels using the  
> following command:
>
> scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB >  
> channels.conf
>
> ...and it starts scanning. It doesn't find any channels until it  
> gets to 31.1, and then it says service is running, gives me the  
> channel information, and then the thing freezes. I can't ctrl+C out  
> of it, and I can't even kill the process from the root account.
>
> This is my schedulesdirect lineup, so I have 2 questions: Why is my  
> computer locking up when I scan channels? Interestingly, it isn't  
> locking the computer up, just the console that the app is running  
> in, and capture card it's connected to. The second question has to  
> do with my channels. I have my antenna pointed right at the towers,  
> they're all in the same general location, and as I said, the SD  
> comes in clear.
>

Well, I hooked up one of the pinnacle cards up in a winXP system, and  
scanned all the channels, and the ones I expected to get come in  
crystal clear. So now that I've eliminated the signal strength as a  
question... how can I troubleshoot the drivers? I have the install  
CD, perhaps the firmware I downloaded isn't suitable? I followed the  
instructions here http://www.linuxtv.org/wiki/index.php/ 
Pinnacle_PCTV_HD_Card_%28800i%29 which basically told me to download  
the firmware, extract it, using included script, and then get the  
source and do a make and make install. I do that, and everything  
appears to be working, the card is detected... it just freezes when  
it's scanning channels. I also managed to copy all the channel  
frequencies down while I was in windows, so is there a template I can  
put those into in order to test my card without scanning?

~Jon

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
