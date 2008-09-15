Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1KfMMW-0006ul-05
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 00:16:05 +0200
Received: by py-out-1112.google.com with SMTP id a29so1823611pyi.0
	for <linux-dvb@linuxtv.org>; Mon, 15 Sep 2008 15:15:58 -0700 (PDT)
Message-ID: <e32e0e5d0809151515y26eab250x697fea6768af93af@mail.gmail.com>
Date: Mon, 15 Sep 2008 15:15:57 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: linux-dvb@linuxtv.org, "Steven Toth" <stoth@linuxtv.org>
MIME-Version: 1.0
Subject: Re: [linux-dvb] why opensource will fail
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0834096795=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0834096795==
Content-Type: multipart/alternative;
	boundary="----=_Part_6940_10425069.1221516957665"

------=_Part_6940_10425069.1221516957665
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>
> Message: 7
> Date: Sat, 13 Sep 2008 16:31:16 -0400
> From: Steven Toth <stoth@linuxtv.org>
> Subject: Re: [linux-dvb] why opensource will fail
> To: Paul Chubb <paulc@singlespoon.org.au>
> Cc: linux dvb <linux-dvb@linuxtv.org>
> Message-ID: <48CC2314.4090800@linuxtv.org>
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
>
> Paul Chubb wrote:
> > Hi,
> >      now that I have your attention:-{)=
>
> .... You've also had my attention in the past, if I recall I have you
> tips about not using cx_write, instead using cx_set/cx_clear.
>
> Your latest patch still doesn't have those changes btw. ;)
>
>
> >
> > I believe that this community has a real problem. There appears to be
> > little willingness to help and mentor newcomers. This will limit the
> > effectiveness of the community because it will hinder expansion of
> > people who are both willing and able to work on the code. Eventually
> > this issue  will lead to the community dying simply because you have
> > people leaving but few joining.
>
> I disagree with everything you've just said, but that's just my opinion.
>
>
> >
> > The card I was working on has been around for  a while now. There have
> > been three attempts so far to get it working with Linux. Two in this
> > community and one against the mcentral.de tree. Both attempts in this
> > community have failed not because of a lack of willingness of the people
> > involved to do the hard yards but because of the inability of the
> > community to mentor and help newcomers.
>
>
> Did I not try to help you? The one piece of initial feedback I gave you,
> you ignored. (see my opening statement).
>
> I'm always willing to help people, but they also have to demonstrate
> that they are applying themselves, doing basic research, asking specific
> questions ... rather than, here's my patch - and What's Wrong with it.
>
>
> >
> > The third attempt by a Czech programmer succeeded, however it is
> > dependent on the mcentral.de tree and the author appears to have made no
> > attempt to get the patch into the tree. The original instructions to
> > produce a driver set are in Czech. However instructions in english for
> > 2.6.22 are available - ubuntu gutsy. I will soon be putting up
> > instructions for 2.6.24 - hardy. They may even work  for later revisions
> > since the big issue was incompatible versioning.
> >
> > I understand from recent posts to this list that many in the community
> > are disturbed by the existence of mcentral.de. Well every person from
> > now on who wants to run the Leadtek Winfast DTV1800H will be using that
> > tree. Since the card is excellent value for what it is, there should be
> > lots of them. Not helping newcomers who are trying to add cards has led
> > and will lead to increased fragmentation.
>
> So port the mcentral.de details into the kernel, I doubt they'll be
> significantly different.... we're talking about adding support for an
> existing card, it's not a lot of engineering work.
>
>
> >
> > And before you say or think that we are all volunteers here, I am a
> > volunteer also. I have spent close to 3 weeks on this code and it is
> > very close to working. The biggest difference between working code in
> > the mcentral.de tree and the patch I was working on is the firmware that
> > is used.
>
> ... and your efforts are valuable.
>
> Markus (mcentral.de) is paid to work on Linux, just to be clear.
>
> Your last message on that thread said: "xc2028 2-0061: xc2028/3028
> firmware name not set!"
>
> You could of asked a second time before taking the opportunity to vent,
> and taking the community to task.
>
> Showing patience and perseverance is what most other newcomers demonstrate.
>
>
> >
> > Finally you might consider that if few developers are prepared to work
> > on the v4l-dvb tree, then much of the fun will disappear because those
> > few will have to do everything.
>
> Whether we have 3 people or 30, it's never enough.
>
> In my experience, people who join the list then vent all over it are
> rarely around long enough to make a difference. They often think they
> know more about the community than the community itself.
>
> On the other hand, the people who join and ask well thought out
> questions, describe their failures and working assumptions, then
> demonstrate a willingness to learn attract a mentor very quickly.
>
> ... just my opinion of course :)
>
> If you want to make progress with the leadtek card then another look at
> the feedback I gave you, then approach the group again with a more
> insightful email.
>
> Maybe someone will help you then.
>
> - Steve
>
>
I would like to respond to this because I have been sending messages to the
list asking for help, but after a couple initial suggestions, I have been
completely ignored.  I need to work with the cx23885 drivers with analog
support that Steve wrote, because they are the only ones around, but how am
I supposed to get them to work if the person who wrote them will not help
me.   I even reported progress, but I was still ignored.  In fact, I saw
other people get help with questions that were as silly as mine, but for
some reason I cannot get any help from Steve or anyone else on the list.  I
have said before that I am willing to do some of the work, but there is a
steep learning curve.
If I have done something against the rules or to deserve this treatment, I
would appreciate someone letting me know instead of just ignoring me.  Where
else can I go for help?

If anyone has any suggestions about what I can do, please see my latest
posts to the list about analog support for cx23885 cards.  Thank you.

     --Tim




-- 
--Tim

------=_Part_6940_10425069.1221516957665
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div class="gmail_quote"><blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">Message: 7<br>
Date: Sat, 13 Sep 2008 16:31:16 -0400<br>
From: Steven Toth &lt;<a href="mailto:stoth@linuxtv.org">stoth@linuxtv.org</a>&gt;<br>
Subject: Re: [linux-dvb] why opensource will fail<br>
To: Paul Chubb &lt;<a href="mailto:paulc@singlespoon.org.au">paulc@singlespoon.org.au</a>&gt;<br>
Cc: linux dvb &lt;<a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>&gt;<br>
Message-ID: &lt;<a href="mailto:48CC2314.4090800@linuxtv.org">48CC2314.4090800@linuxtv.org</a>&gt;<br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed<br>
<br>
Paul Chubb wrote:<br>
&gt; Hi,<br>
&gt; &nbsp; &nbsp; &nbsp;now that I have your attention:-{)=<br>
<br>
.... You&#39;ve also had my attention in the past, if I recall I have you<br>
tips about not using cx_write, instead using cx_set/cx_clear.<br>
<br>
Your latest patch still doesn&#39;t have those changes btw. ;)<br>
<br>
<br>
&gt;<br>
&gt; I believe that this community has a real problem. There appears to be<br>
&gt; little willingness to help and mentor newcomers. This will limit the<br>
&gt; effectiveness of the community because it will hinder expansion of<br>
&gt; people who are both willing and able to work on the code. Eventually<br>
&gt; this issue &nbsp;will lead to the community dying simply because you have<br>
&gt; people leaving but few joining.<br>
<br>
I disagree with everything you&#39;ve just said, but that&#39;s just my opinion.<br>
<br>
<br>
&gt;<br>
&gt; The card I was working on has been around for &nbsp;a while now. There have<br>
&gt; been three attempts so far to get it working with Linux. Two in this<br>
&gt; community and one against the <a href="http://mcentral.de" target="_blank">mcentral.de</a> tree. Both attempts in this<br>
&gt; community have failed not because of a lack of willingness of the people<br>
&gt; involved to do the hard yards but because of the inability of the<br>
&gt; community to mentor and help newcomers.<br>
<br>
<br>
Did I not try to help you? The one piece of initial feedback I gave you,<br>
you ignored. (see my opening statement).<br>
<br>
I&#39;m always willing to help people, but they also have to demonstrate<br>
that they are applying themselves, doing basic research, asking specific<br>
questions ... rather than, here&#39;s my patch - and What&#39;s Wrong with it.<br>
<br>
<br>
&gt;<br>
&gt; The third attempt by a Czech programmer succeeded, however it is<br>
&gt; dependent on the <a href="http://mcentral.de" target="_blank">mcentral.de</a> tree and the author appears to have made no<br>
&gt; attempt to get the patch into the tree. The original instructions to<br>
&gt; produce a driver set are in Czech. However instructions in english for<br>
&gt; 2.6.22 are available - ubuntu gutsy. I will soon be putting up<br>
&gt; instructions for 2.6.24 - hardy. They may even work &nbsp;for later revisions<br>
&gt; since the big issue was incompatible versioning.<br>
&gt;<br>
&gt; I understand from recent posts to this list that many in the community<br>
&gt; are disturbed by the existence of <a href="http://mcentral.de" target="_blank">mcentral.de</a>. Well every person from<br>
&gt; now on who wants to run the Leadtek Winfast DTV1800H will be using that<br>
&gt; tree. Since the card is excellent value for what it is, there should be<br>
&gt; lots of them. Not helping newcomers who are trying to add cards has led<br>
&gt; and will lead to increased fragmentation.<br>
<br>
So port the <a href="http://mcentral.de" target="_blank">mcentral.de</a> details into the kernel, I doubt they&#39;ll be<br>
significantly different.... we&#39;re talking about adding support for an<br>
existing card, it&#39;s not a lot of engineering work.<br>
<br>
<br>
&gt;<br>
&gt; And before you say or think that we are all volunteers here, I am a<br>
&gt; volunteer also. I have spent close to 3 weeks on this code and it is<br>
&gt; very close to working. The biggest difference between working code in<br>
&gt; the <a href="http://mcentral.de" target="_blank">mcentral.de</a> tree and the patch I was working on is the firmware that<br>
&gt; is used.<br>
<br>
... and your efforts are valuable.<br>
<br>
Markus (<a href="http://mcentral.de" target="_blank">mcentral.de</a>) is paid to work on Linux, just to be clear.<br>
<br>
Your last message on that thread said: &quot;xc2028 2-0061: xc2028/3028<br>
firmware name not set!&quot;<br>
<br>
You could of asked a second time before taking the opportunity to vent,<br>
and taking the community to task.<br>
<br>
Showing patience and perseverance is what most other newcomers demonstrate.<br>
<br>
<br>
&gt;<br>
&gt; Finally you might consider that if few developers are prepared to work<br>
&gt; on the v4l-dvb tree, then much of the fun will disappear because those<br>
&gt; few will have to do everything.<br>
<br>
Whether we have 3 people or 30, it&#39;s never enough.<br>
<br>
In my experience, people who join the list then vent all over it are<br>
rarely around long enough to make a difference. They often think they<br>
know more about the community than the community itself.<br>
<br>
On the other hand, the people who join and ask well thought out<br>
questions, describe their failures and working assumptions, then<br>
demonstrate a willingness to learn attract a mentor very quickly.<br>
<br>
... just my opinion of course :)<br>
<br>
If you want to make progress with the leadtek card then another look at<br>
the feedback I gave you, then approach the group again with a more<br>
insightful email.<br>
<br>
Maybe someone will help you then.<br>
<br>
- Steve<br>



<br>
</blockquote></div><div><br></div>I would like to respond to this because I have been sending messages to the list asking for help, but after a couple initial suggestions, I have been completely ignored.&nbsp;&nbsp;I&nbsp;need to work with the cx23885 drivers with analog support that Steve wrote, because they are the only ones around, but how am I supposed to get them to work if the person who wrote them will not help me.&nbsp;&nbsp;&nbsp;I even reported progress, but I was still ignored. &nbsp;In fact, I saw other people get help with questions that were as silly as mine, but for some reason I cannot get any help from Steve or anyone else on the list. &nbsp;I have said before that I am willing to do some of the work, but there is a steep learning curve. &nbsp;<div>
<br></div><div>If I have done something against the rules or to deserve this treatment, I would appreciate someone letting me know instead of just ignoring me. &nbsp;Where else can I go for help?&nbsp;</div><div><br></div><div>If anyone has any suggestions about what I can do, please see my latest posts to the list about analog support for cx23885 cards. &nbsp;Thank you.</div>
<div><br></div><div>&nbsp;&nbsp; &nbsp; --Tim<br><div><div><br></div><div><br><br clear="all"><br>-- <br> --Tim<br>
</div></div></div></div>

------=_Part_6940_10425069.1221516957665--


--===============0834096795==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0834096795==--
