Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <orbus42@gmail.com>) id 1KTqCP-00041v-1x
	for linux-dvb@linuxtv.org; Fri, 15 Aug 2008 05:42:02 +0200
Received: by yx-out-2324.google.com with SMTP id 8so475189yxg.41
	for <linux-dvb@linuxtv.org>; Thu, 14 Aug 2008 20:41:56 -0700 (PDT)
Message-ID: <8fcafd2c0808142041p3b2800e1qa4e4b3bbfe11b30a@mail.gmail.com>
Date: Thu, 14 Aug 2008 22:41:55 -0500
From: "James Lucas" <orbus42@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <8fcafd2c0808142040p357a2efep97354122a0b5e11f@mail.gmail.com>
MIME-Version: 1.0
References: <8fcafd2c0808131723l21031daej9e9ae3eeabfa57f7@mail.gmail.com>
	<48A37D44.7090808@linuxtv.org>
	<8fcafd2c0808131806l1fcc7563v121715d937d39a5d@mail.gmail.com>
	<8fcafd2c0808131840u4fe27c7dq84953bd34d24e0b1@mail.gmail.com>
	<8fcafd2c0808132039h4d0ada9xef21a8502e495b9d@mail.gmail.com>
	<48A43DF3.6000705@linuxtv.org>
	<bd41c5f0808140745q7ac4cc31tbddfb7525d29a799@mail.gmail.com>
	<8fcafd2c0808142040p357a2efep97354122a0b5e11f@mail.gmail.com>
Subject: Re: [linux-dvb] Digital tuning failing on Pinnacle 800i with dmesg
	output
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2111184586=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2111184586==
Content-Type: multipart/alternative;
	boundary="----=_Part_109997_14000488.1218771715934"

------=_Part_109997_14000488.1218771715934
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Aug 14, 2008 at 9:45 AM, Chaogui Zhang <czhang1974@gmail.com> wrote:

> On Thu, Aug 14, 2008 at 2:15 PM, Steven Toth <stoth@linuxtv.org> wrote:
> > James Lucas wrote:
> >> On Wed, Aug 13, 2008 at 8:40 PM, James Lucas <orbus42@gmail.com
> >> <mailto:orbus42@gmail.com>> wrote:
> >>
> >>     Anyway, update.  Installed in the windows machine, and got the
> >>     drivers installed successfully, but the player software that comes
> >>     with the card requires windows xp, and the newest version of windows
> >>     I have is 2000.  I know analog capture is pretty well supported in
> >>     windows by things like virtualdub and media player classic, but do
> >>     you know of any apps I can use to test the HD functionality?
> >>
> >>     While I had the card out, got the following from visual inspection:
> >>
> >>     Printed on the PCB:
> >>     pctv 800i rev 1.1
> >>
> >>     There were two large visible chips on the card:
> >>     Samsung C649 S5H1409X01-T0  N079X
> >>
> >>     Conexant Broadcast Decoder  CX23883-39  72013496  0729 Korea
> >>
> >>     I imagine the tuner chip is hidden under the metal box (shielding?).
> >>
> >>     James
> >>
> >>
> >>
> >> Another update - I spoke too soon.  One of the windows drivers is
> >> refusing to load properly.  I don't know if the signifies a bad card or
> >> just that the driver doesn't work on anything less than xp.  I don't
> >> have any way to test at the moment.  I'm happy to try anything you want
> >> in the way of diagnosis under linux though.
> >
> > I don't think anyone else is reporting i2c issues on that board, so it's
> > possible you just have a bad unit.
>
> I saw similar i2c error messages back when we were trying to add
> support for the card (I never posted on the list about it because that
> happened when I was fiddling with the code). I do not remember the
> specifics, but it went away later on as the code matured. It might
> have something to do with multiple instances of the driver being
> attached to the xc5000, but we certainly cannot rule out the
> possibility of a bad unit.
>
> >
> > It goes without saying, try to bring up the baord on a supported windows
> > platform to verify it... or perhaps take it to a neighbours house a
> > wreck his xp install ;)
> >
> > If you get to the point of it working in windows but not on Linux then
> > we'll be able to make progress.
> >
> > - Steve
> >
>
> --
> Chaogui Zhang
>

Alright - thanks for the replies.  My brother has an xp box, so maybe I can
convince him to let me stick it in there.  I probably will not have time to
do that for a little while though - I'll get back to you when I have
something one way or another.

James

P.S. Sorry about the double send Chaogui.  Foiled by gmail again! :/

------=_Part_109997_14000488.1218771715934
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div class="gmail_quote"><div dir="ltr"><div><div class="Wj3C7c">On Thu, Aug 14, 2008 at 9:45 AM, Chaogui Zhang <span dir="ltr">&lt;<a href="mailto:czhang1974@gmail.com" target="_blank">czhang1974@gmail.com</a>&gt;</span> wrote:<br>
<div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div><div></div><div>On Thu, Aug 14, 2008 at 2:15 PM, Steven Toth &lt;<a href="mailto:stoth@linuxtv.org" target="_blank">stoth@linuxtv.org</a>&gt; wrote:<br>
&gt; James Lucas wrote:<br>
&gt;&gt; On Wed, Aug 13, 2008 at 8:40 PM, James Lucas &lt;<a href="mailto:orbus42@gmail.com" target="_blank">orbus42@gmail.com</a><br>
&gt;&gt; &lt;mailto:<a href="mailto:orbus42@gmail.com" target="_blank">orbus42@gmail.com</a>&gt;&gt; wrote:<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; Anyway, update. &nbsp;Installed in the windows machine, and got the<br>
&gt;&gt; &nbsp; &nbsp; drivers installed successfully, but the player software that comes<br>
&gt;&gt; &nbsp; &nbsp; with the card requires windows xp, and the newest version of windows<br>
&gt;&gt; &nbsp; &nbsp; I have is 2000. &nbsp;I know analog capture is pretty well supported in<br>
&gt;&gt; &nbsp; &nbsp; windows by things like virtualdub and media player classic, but do<br>
&gt;&gt; &nbsp; &nbsp; you know of any apps I can use to test the HD functionality?<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; While I had the card out, got the following from visual inspection:<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; Printed on the PCB:<br>
&gt;&gt; &nbsp; &nbsp; pctv 800i rev 1.1<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; There were two large visible chips on the card:<br>
&gt;&gt; &nbsp; &nbsp; Samsung C649 S5H1409X01-T0 &nbsp;N079X<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; Conexant Broadcast Decoder &nbsp;CX23883-39 &nbsp;72013496 &nbsp;0729 Korea<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; I imagine the tuner chip is hidden under the metal box (shielding?).<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; James<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; Another update - I spoke too soon. &nbsp;One of the windows drivers is<br>
&gt;&gt; refusing to load properly. &nbsp;I don&#39;t know if the signifies a bad card or<br>
&gt;&gt; just that the driver doesn&#39;t work on anything less than xp. &nbsp;I don&#39;t<br>
&gt;&gt; have any way to test at the moment. &nbsp;I&#39;m happy to try anything you want<br>
&gt;&gt; in the way of diagnosis under linux though.<br>
&gt;<br>
&gt; I don&#39;t think anyone else is reporting i2c issues on that board, so it&#39;s<br>
&gt; possible you just have a bad unit.<br>
<br>
</div></div>I saw similar i2c error messages back when we were trying to add<br>
support for the card (I never posted on the list about it because that<br>
happened when I was fiddling with the code). I do not remember the<br>
specifics, but it went away later on as the code matured. It might<br>
have something to do with multiple instances of the driver being<br>
attached to the xc5000, but we certainly cannot rule out the<br>
possibility of a bad unit.<br>
<div><br>
&gt;<br>
&gt; It goes without saying, try to bring up the baord on a supported windows<br>
&gt; platform to verify it... or perhaps take it to a neighbours house a<br>
&gt; wreck his xp install ;)<br>
&gt;<br>
&gt; If you get to the point of it working in windows but not on Linux then<br>
&gt; we&#39;ll be able to make progress.<br>
&gt;<br>
&gt; - Steve<br>
&gt;<br>
<br>
</div>--<br>
<font color="#888888">Chaogui Zhang<br>
</font></blockquote></div><br></div></div>Alright - thanks for the replies.&nbsp; My brother has an xp box, so maybe I can convince him to let me stick it in there.&nbsp; I probably will not have time to do that for a little while though - I&#39;ll get back to you when I have something one way or another.<br>

<br>James<br><br>P.S. Sorry about the double send Chaogui.&nbsp; Foiled by gmail again! :/<br></div>
</div><br></div>

------=_Part_109997_14000488.1218771715934--


--===============2111184586==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2111184586==--
