Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta04.westchester.pa.mail.comcast.net ([76.96.62.40])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <quielb@ecst.csuchico.edu>) id 1KVfMm-0006kQ-MV
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 06:32:27 +0200
Message-ID: <48AB9E2C.50502@ecst.csuchico.edu>
Date: Tue, 19 Aug 2008 21:31:40 -0700
From: Barry Quiel <quielb@ecst.csuchico.edu>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <6664ae760808181614g47d65c7atf71d564d815934a8@mail.gmail.com>
	<48AAF9FB.6010108@ecst.csuchico.edu>
	<6664ae760808191345y3a0c5bd8odd4f5f7ca969b3b@mail.gmail.com>
	<48AB3507.8030302@linuxtv.org> <48AB9098.1090700@ecst.csuchico.edu>
	<48AB94D9.8020304@linuxtv.org>
In-Reply-To: <48AB94D9.8020304@linuxtv.org>
Cc: linux-dvb@linuxtv.org, Jay Modi <jaymode@gmail.com>
Subject: Re: [linux-dvb] Hauppauge HVR-1800 Analog issues
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

Steven Toth wrote:
> Barry Quiel wrote:
>> Steven Toth wrote:
>>> Jay Modi wrote:
>>>> On Tue, Aug 19, 2008 at 12:51 PM, Barry Quiel 
>>>> <quielb@ecst.csuchico.edu <mailto:quielb@ecst.csuchico.edu>> wrote:
>>>>
>>>>
>>>>     I've got the same problem.  I'm running on a fedora 9 box, so at
>>>>     least that tells you its not OS related.
>>>>
>>>>     I posted this problem on the list a while back and didn't get any
>>>>     response.  Here is my post out of the archives:
>>>>
>>>>     http://linuxtv.org/pipermail/linux-dvb/2008-July/027367.html
>>>>     http://linuxtv.org/pipermail/linux-dvb/2008-August/027670.html
>>>>
>>>>     It makes me feel a little bit better that its not just me.
>>>>
>>>>
>>>>
>>>> I am glad to know someone else has this error too.
>>>>
>>>> For the devs, is there anything Barry and I can do to help 
>>>> diagnose/test/fix this problem?
>>>
>>> # make unload
>>> # modprobe cx25840 debug=1
>>> # modprobe cx23885 debug=1
>>>
>>> Then cat /dev/video1 >test.mpg
>>>
>>> Better?
>>>
>>> - Steve
>>>
>>
>> I pulled the PVR-500 and rebooted.  Modprob and all that, still no 
>> video just static.
>
> Start tvtime (/dev/video0) then tune a channel, ensure video is 
> working correctly.
>
> Now try the cat /dev/video1 >test.mpg again.
>
> - Steve

Same results.  I get static from both /dev/video devices.  I don't get 
the error when using the /dev/video0 device, if that's helpful at all


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
