Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L0MtG-0006bA-BQ
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 22:04:42 +0100
Received: by qw-out-2122.google.com with SMTP id 9so416577qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 13:04:37 -0800 (PST)
Message-ID: <c74595dc0811121304o44e4270am67173ed5857f6945@mail.gmail.com>
Date: Wed, 12 Nov 2008 23:04:37 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Darron Broad" <darron@kewl.org>
In-Reply-To: <30422.1226523269@kewl.org>
MIME-Version: 1.0
References: <c74595dc0811121232s48a95a14v93edf27360ed5c21@mail.gmail.com>
	<30422.1226523269@kewl.org>
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] S2API tune return code - potential problem?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0880870676=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0880870676==
Content-Type: multipart/alternative;
	boundary="----=_Part_13484_26999517.1226523877911"

------=_Part_13484_26999517.1226523877911
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Nov 12, 2008 at 10:54 PM, Darron Broad <darron@kewl.org> wrote:

> In message <c74595dc0811121232s48a95a14v93edf27360ed5c21@mail.gmail.com>,
> "Alex Betis" wrote:
> >
> >Hi All,
>
> Hi.
>
> >A question regarding the error code returned from the driver when using
> >DTV_TUNE property.
> >Following the code I came to dvb_frontend_ioctl_legacy function and
> reached
> >the FE_SET_FRONTEND case.
> >Looking on the logic I couldn't see any handling of error tuning, an event
> >is added to the frontend and zero is returned:
> >
> >        fepriv->state = FESTATE_RETUNE;
> >        dvb_frontend_wakeup(fe);
> >        dvb_frontend_add_event(fe, 0);
> >        fepriv->status = 0;
> >        err = 0;
> >        break;
> >
> >How should an application know that DTV_TUNE command succeed?
> >Monitoring the LOCK bit is not good, here's an example why I ask the
> >question:
> >
> >Assuming the cx24116 driver is locked on a channel. Application sends tune
> >command to another channel while specifying
> >AUTO settings for modulation and FEC. The driver for that chip cant handle
> >AUTO settings and return error, while its still connected
> >to previous channel. So in that case LOCK bit will be ON, while the tune
> >command was ignored.
> >
> >I thought of an workaround to query the driver for locked frequency and
> >check whenever its in bounds of frequency that was ordered
> >to be tuned + - some delta, but that's a very dirty solution.
> >
> >Any thoughts? Or I'm missing something?
>
> Correct me if I am wrong, but I remember looking at this before...
>
> The problem is that no capabilities are available for S2API demods as yet
> so TUNE always succeeds whether the parameters are wrong or right.
>
> What is needed is:
> 1. caps for s2api aware demods.
> 2. extend dvb_frontend_check_parameters() for s2api aware demods.
>
You mean passing the parameter to the demods to be checked before performing
the tuning?
Is there an example of that usage?
What about some unexpected failures that can't be checked before the tuning?
Can't think of a real example since I'm not too familiar with
the code.
I thought about a property of "last error code" that can be queried from the
driver, but in that case the application has to be aware when
the tuning is finished.


>
> This hasn't been done as yet.
>
> cya
>
> --
>
>  // /
> {:)==={ Darron Broad <darron@kewl.org>
>  \\ \
>
>

------=_Part_13484_26999517.1226523877911
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br><div class="gmail_quote">On Wed, Nov 12, 2008 at 10:54 PM, Darron Broad <span dir="ltr">&lt;<a href="mailto:darron@kewl.org">darron@kewl.org</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
In message &lt;<a href="mailto:c74595dc0811121232s48a95a14v93edf27360ed5c21@mail.gmail.com">c74595dc0811121232s48a95a14v93edf27360ed5c21@mail.gmail.com</a>&gt;, &quot;Alex Betis&quot; wrote:<br>
&gt;<br>
&gt;Hi All,<br>
<br>
Hi.<br>
<div><div></div><div class="Wj3C7c"><br>
&gt;A question regarding the error code returned from the driver when using<br>
&gt;DTV_TUNE property.<br>
&gt;Following the code I came to dvb_frontend_ioctl_legacy function and reached<br>
&gt;the FE_SET_FRONTEND case.<br>
&gt;Looking on the logic I couldn&#39;t see any handling of error tuning, an event<br>
&gt;is added to the frontend and zero is returned:<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp;fepriv-&gt;state = FESTATE_RETUNE;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp;dvb_frontend_wakeup(fe);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp;dvb_frontend_add_event(fe, 0);<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp;fepriv-&gt;status = 0;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp;err = 0;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp;break;<br>
&gt;<br>
&gt;How should an application know that DTV_TUNE command succeed?<br>
&gt;Monitoring the LOCK bit is not good, here&#39;s an example why I ask the<br>
&gt;question:<br>
&gt;<br>
&gt;Assuming the cx24116 driver is locked on a channel. Application sends tune<br>
&gt;command to another channel while specifying<br>
&gt;AUTO settings for modulation and FEC. The driver for that chip cant handle<br>
&gt;AUTO settings and return error, while its still connected<br>
&gt;to previous channel. So in that case LOCK bit will be ON, while the tune<br>
&gt;command was ignored.<br>
&gt;<br>
&gt;I thought of an workaround to query the driver for locked frequency and<br>
&gt;check whenever its in bounds of frequency that was ordered<br>
&gt;to be tuned + - some delta, but that&#39;s a very dirty solution.<br>
&gt;<br>
&gt;Any thoughts? Or I&#39;m missing something?<br>
<br>
</div></div>Correct me if I am wrong, but I remember looking at this before...<br>
<br>
The problem is that no capabilities are available for S2API demods as yet<br>
so TUNE always succeeds whether the parameters are wrong or right.<br>
<br>
What is needed is:<br>
1. caps for s2api aware demods.<br>
2. extend dvb_frontend_check_parameters() for s2api aware demods.<br>
</blockquote><div>You mean passing the parameter to the demods to be checked before performing the tuning?<br>Is there an example of that usage?<br>What about some unexpected failures that can&#39;t be checked before the tuning? Can&#39;t think of a real example since I&#39;m not too familiar with<br>
the code. <br>I thought about a property of &quot;last error code&quot; that can be queried from the driver, but in that case the application has to be aware when<br>the tuning is finished.<br>&nbsp;<br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
This hasn&#39;t been done as yet.<br>
<br>
cya<br>
<font color="#888888"><br>
--<br>
<br>
&nbsp;// /<br>
{:)==={ Darron Broad &lt;<a href="mailto:darron@kewl.org">darron@kewl.org</a>&gt;<br>
&nbsp;\\ \<br>
<br>
</font></blockquote></div><br></div>

------=_Part_13484_26999517.1226523877911--


--===============0880870676==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0880870676==--
