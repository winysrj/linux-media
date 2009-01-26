Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <2manybills@gmail.com>) id 1LRU0y-0005V2-Ew
	for linux-dvb@linuxtv.org; Mon, 26 Jan 2009 17:08:45 +0100
Received: by el-out-1112.google.com with SMTP id s27so1239329ele.14
	for <linux-dvb@linuxtv.org>; Mon, 26 Jan 2009 08:08:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
	<157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>
	<157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>
	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>
	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>
Date: Mon, 26 Jan 2009 16:08:39 +0000
Message-ID: <157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>
From: Chris Silva <2manybills@gmail.com>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on
	HDchannels
Reply-To: linux-media@vger.kernel.org
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

On Mon, Jan 26, 2009 at 3:51 PM, Chris Silva <2manybills@gmail.com> wrote:
> On Mon, Jan 26, 2009 at 3:44 PM, Alex Betis <alex.betis@gmail.com> wrote:
>> On Mon, Jan 26, 2009 at 5:41 PM, Chris Silva <2manybills@gmail.com> wrote:
>>>
>>> On Mon, Jan 26, 2009 at 2:40 PM, Newsy Paper
>>> <newspaperman_germany@yahoo.com> wrote:
>>> > the transponders you don't get lock are problem transponders of s2-3200.
>>> > The driver is still not able to lock on dvb-s2 30000 3/4 transponders :(
>>> >
>>> > Which software do you use to play HD content?
>>> > you need either xine-lib 1.2 with external ffmpeg (recent developer's
>>> > version).
>>> > or xine-vdpau (if you have a NVIDIA graka that supports h264 hw
>>> > acceleration).
>>> >
>>> > regards
>>> >
>>> > Newsy
>>>
>>> I can confirm this. I use S30W (Hispasat) and one of the providers,
>>> Meo, broadcasts everything on DVB-S2 30000 3/4.
>>> I can't get a lock on any of the transponders/channels. And to make
>>> matters worse, not even scan-s2 can get a really usable channel list.
>>> I had to build the list by hand, according to
>>> http://pt.kingofsat.net/pack-meo.php page.
>>>
>>> And it still doesn't work.
>>>
>>> I use vdr-xine and xineliboutput with vdr 1.7.0 and up, plus
>>> xine-vdpau to no avail.
>>>
>>> What's the point of having a DVB-S2 card if we can't tune to those
>>> channels? What's missing in the S2-3200 drivers?
>>
>> What drivers do you use?
>> I saw that Igor did some changes in his repository to lock on high SR
>> channels.
>>
>
> I've tried with both v4l-dvb and Igor repository. Haven't tried with
> latest changes Igor made.
>
> I'll try it tonight and comment on the state.
>
> But for now, I'm somewhat disappointed. It's been over 6 months trying
> to make DVB-S2 transponders to work and no result to show.
>
> But wey... DVB-S works perfectly.
>
> Chris
>

Latest changes I can see at
http://mercurial.intuxication.org/hg/s2-liplianin/ were made about 7
to 10 days ago. Is this correct? If that's correct, then I'm using
latest Igor drivers. And behavior described above is what I'm getting.

I can't see anything related do high SR channels on Igor repository.

Chris

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
