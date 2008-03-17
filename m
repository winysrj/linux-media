Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jon.the.wise.gdrive@gmail.com>) id 1Jb4N7-0004Xr-Al
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 02:42:44 +0100
Received: by rv-out-0910.google.com with SMTP id b22so3736491rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 16 Mar 2008 18:42:34 -0700 (PDT)
Message-ID: <c70a981c0803161842s53865609la10fde187c198bfd@mail.gmail.com>
Date: Sun, 16 Mar 2008 18:42:34 -0700
From: "Jonny B" <jon.the.wise.gdrive@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <67E2C7B4-2D3D-43C6-ADC7-A53420DA5014@gmail.com>
MIME-Version: 1.0
References: <7506F33A-1475-4D05-9562-885CAEA8C463@gmail.com>
	<67E2C7B4-2D3D-43C6-ADC7-A53420DA5014@gmail.com>
Subject: Re: [linux-dvb] Pinnacle HDTV PCI issues
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1715846495=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1715846495==
Content-Type: multipart/alternative;
	boundary="----=_Part_7458_4668373.1205718154804"

------=_Part_7458_4668373.1205718154804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Mar 16, 2008 at 6:16 AM, Jon <jon.the.wise.gdrive@gmail.com> wrote:

>
> On Mar 16, 2008, at 3:40 AM, Jon wrote:
>
> > Hello,
> >
> > I have a problem with my capture device.
> >
> > First a little history. I'm running a openSUSE 10.3 system with
> > mythtv and have had a frame-grabber (bt878) in it until recently. I
> > just upgraded to a pair of pinnacle HDTV pci cards. I just
> > downloaded the source and compiled it this afternoon, following the
> > instructions on the wiki. I have a large antenna on the roof, and I
> > get channels 3, 6, 10, 13, 31, 40 and 58 all clearly with SD.
> >
> > So, the problem is, I am trying to scan for HD channels using the
> > following command:
> >
> > scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB >
> > channels.conf
> >
> > ...and it starts scanning. It doesn't find any channels until it
> > gets to 31.1, and then it says service is running, gives me the
> > channel information, and then the thing freezes. I can't ctrl+C out
> > of it, and I can't even kill the process from the root account.
> >
> > This is my schedulesdirect lineup, so I have 2 questions: Why is my
> > computer locking up when I scan channels? Interestingly, it isn't
> > locking the computer up, just the console that the app is running
> > in, and capture card it's connected to. The second question has to
> > do with my channels. I have my antenna pointed right at the towers,
> > they're all in the same general location, and as I said, the SD
> > comes in clear.
> >
>
> Well, I hooked up one of the pinnacle cards up in a winXP system, and
> scanned all the channels, and the ones I expected to get come in
> crystal clear. So now that I've eliminated the signal strength as a
> question... how can I troubleshoot the drivers? I have the install
> CD, perhaps the firmware I downloaded isn't suitable? I followed the
> instructions here http://www.linuxtv.org/wiki/index.php/
> Pinnacle_PCTV_HD_Card_%28800i%29 which basically told me to download
> the firmware, extract it, using included script, and then get the
> source and do a make and make install. I do that, and everything
> appears to be working, the card is detected... it just freezes when
> it's scanning channels. I also managed to copy all the channel
> frequencies down while I was in windows, so is there a template I can
> put those into in order to test my card without scanning?
>
> ~Jon
>


Spent some more time poking around at things. It seems like it must be a
driver issue, because at this point, I can attempt to tune (using azap) to a
specific channel (using the frequencies I got out of windows) and it will
lock onto the channel, and then it won't let go of the card. I can't ctrl+c,
I can't sudo kill -9 the process, the only solution is to reboot. I've tried
a couple different releases of the v4l-dvb code, and they all seem to do the
same thing.

Are there ANY ideas? I can send my dmesg when I get home, but right now I'm
at work (until 7am pst) so, if there's any ideas that I can try when I get
home, I'm ready to hear them.

~Jon

------=_Part_7458_4668373.1205718154804
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">On Sun, Mar 16, 2008 at 6:16 AM, Jon &lt;<a href="mailto:jon.the.wise.gdrive@gmail.com">jon.the.wise.gdrive@gmail.com</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class="Ih2E3d"><br>
On Mar 16, 2008, at 3:40 AM, Jon wrote:<br>
<br>
&gt; Hello,<br>
&gt;<br>
&gt; I have a problem with my capture device.<br>
&gt;<br>
&gt; First a little history. I&#39;m running a openSUSE 10.3 system with<br>
&gt; mythtv and have had a frame-grabber (bt878) in it until recently. I<br>
&gt; just upgraded to a pair of pinnacle HDTV pci cards. I just<br>
&gt; downloaded the source and compiled it this afternoon, following the<br>
&gt; instructions on the wiki. I have a large antenna on the roof, and I<br>
&gt; get channels 3, 6, 10, 13, 31, 40 and 58 all clearly with SD.<br>
&gt;<br>
&gt; So, the problem is, I am trying to scan for HD channels using the<br>
&gt; following command:<br>
&gt;<br>
&gt; scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB &gt;<br>
&gt; channels.conf<br>
&gt;<br>
&gt; ...and it starts scanning. It doesn&#39;t find any channels until it<br>
&gt; gets to 31.1, and then it says service is running, gives me the<br>
&gt; channel information, and then the thing freezes. I can&#39;t ctrl+C out<br>
&gt; of it, and I can&#39;t even kill the process from the root account.<br>
&gt;<br>
&gt; This is my schedulesdirect lineup, so I have 2 questions: Why is my<br>
&gt; computer locking up when I scan channels? Interestingly, it isn&#39;t<br>
&gt; locking the computer up, just the console that the app is running<br>
&gt; in, and capture card it&#39;s connected to. The second question has to<br>
&gt; do with my channels. I have my antenna pointed right at the towers,<br>
&gt; they&#39;re all in the same general location, and as I said, the SD<br>
&gt; comes in clear.<br>
&gt;<br>
<br>
</div>Well, I hooked up one of the pinnacle cards up in a winXP system, and<br>
scanned all the channels, and the ones I expected to get come in<br>
crystal clear. So now that I&#39;ve eliminated the signal strength as a<br>
question... how can I troubleshoot the drivers? I have the install<br>
CD, perhaps the firmware I downloaded isn&#39;t suitable? I followed the<br>
instructions here <a href="http://www.linuxtv.org/wiki/index.php/" target="_blank">http://www.linuxtv.org/wiki/index.php/</a><br>
Pinnacle_PCTV_HD_Card_%28800i%29 which basically told me to download<br>
the firmware, extract it, using included script, and then get the<br>
source and do a make and make install. I do that, and everything<br>
appears to be working, the card is detected... it just freezes when<br>
it&#39;s scanning channels. I also managed to copy all the channel<br>
frequencies down while I was in windows, so is there a template I can<br>
put those into in order to test my card without scanning?<br>
<font color="#888888"><br>
~Jon<br>
</font></blockquote></div><br><br>Spent some more time poking around at things. It seems like it must be a driver issue, because at this point, I can attempt to tune (using azap) to a specific channel (using the frequencies I got out of windows) and it will lock onto the channel, and then it won&#39;t let go of the card. I can&#39;t ctrl+c, I can&#39;t sudo kill -9 the process, the only solution is to reboot. I&#39;ve tried a couple different releases of the v4l-dvb code, and they all seem to do the same thing.<br>
<br>Are there ANY ideas? I can send my dmesg when I get home, but right now I&#39;m at work (until 7am pst) so, if there&#39;s any ideas that I can try when I get home, I&#39;m ready to hear them.<br><br>~Jon<br><br><br>

------=_Part_7458_4668373.1205718154804--


--===============1715846495==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1715846495==--
