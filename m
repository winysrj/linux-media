Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mo.ucina@gmail.com>) id 1Jeoe0-00043f-6q
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 10:43:38 +0100
Received: by rv-out-0910.google.com with SMTP id b22so2684108rvf.41
	for <linux-dvb@linuxtv.org>; Thu, 27 Mar 2008 02:43:30 -0700 (PDT)
Message-ID: <47EB6C3F.8060305@gmail.com>
Date: Thu, 27 Mar 2008 20:43:27 +1100
From: O&M Ugarcina <mo.ucina@gmail.com>
MIME-Version: 1.0
To: Nico Sabbi <Nicola.Sabbi@poste.it>
References: <e40e29dd0803270213r39da40f3h4181589e85ba97b@mail.gmail.com>
	<200803271030.29168.Nicola.Sabbi@poste.it>
In-Reply-To: <200803271030.29168.Nicola.Sabbi@poste.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Recommendations for a DVB-T card for 2.6.24
Reply-To: mo.ucina@gmail.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0894652854=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0894652854==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Nico Sabbi wrote:
<blockquote cite="mid:200803271030.29168.Nicola.Sabbi@poste.it"
 type="cite">
  <pre wrap="">On Thursday 27 March 2008 10:13:09 Eamonn Sullivan wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Hi, I'm a long-time linux user (since the early 1990s, pre-1.0),
but absolutely brand spanking new to mythtv and digital TV cards. I
have a new PC set up with the latest mythbuntu (beta 8.04, due out
in a few weeks). I've been trying to get a Nova-T 500 to work
reliably without much luck. The card (as noted now on the wiki --
unfortunately not when I bought it) has serious problems with the
new Linux kernel. I can't get it to work for more than a few hours
at a time, and the remote is even worse. I'm in London, with a
strong signal (and a booster too), so I don't think that's the
problem. The PC connected to the main TV is a backend/frontend, so
periodically restarting the backend doesn't fix the remote control
problem (you have to log out and log back in again, which is too
painful for what should be as simple to use for the wife and kids
as sky+...)

I've pulled the latest driver sources, followed all the
instructions on the various wiki pages, have the latest firmware,
etc., but I'm ready to give up. I'm going to try an MCE remote,
which by all reports seems well supported in Linux, and I'm ready
to try a new DVB card(s). Dual-tuner is preferred, but I can also
just install two.

Can anyone recommend a DVB card that they know works reliably with
hardy heron (ubuntu 8.04) and/or the 2.6.24 kernel, something
that's available now down at PC World or on amazon.co.uk?

Thanks much in advance.

-Eamonn

    </pre>
  </blockquote>
  <pre wrap=""><!---->
technisat airstar2 pci is perfect. It has a single (and dvb only) 
tuner  with a coaxial pass-through

_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>

  </pre>
</blockquote>
Hello ,<br>
<br>
I think the problem here might be more related to kernel 2.6.24 than
the card it self . There is a thread running already here called
something like Mysterious Behaviours all about kernel 2.6.24 . I my
self was running it for a couple of days . And had many stability
issues with mythtv . The backend would die suddenly after running for
30 to 40 mins , sometimes 1 hour . When trying to start it again it
would keep crashing with error "could not bind to port" . The only way
I could restart the backend would be to restart the whole PC . Finally
I gave up and reverted to kernel 2.6.23 and this is where I am now .
All working ok again . And have not had a mythbackend or frontend crash
since .<br>
<br>
\Milorad<br>
<br>
</body>
</html>


--===============0894652854==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0894652854==--
