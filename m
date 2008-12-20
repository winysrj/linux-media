Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LDpxb-0001Eq-U4
	for linux-dvb@linuxtv.org; Sat, 20 Dec 2008 01:44:54 +0100
Received: by qw-out-2122.google.com with SMTP id 9so370459qwb.17
	for <linux-dvb@linuxtv.org>; Fri, 19 Dec 2008 16:44:47 -0800 (PST)
Message-ID: <412bdbff0812191644k3d1c3ebw42a2930b1202e22b@mail.gmail.com>
Date: Fri, 19 Dec 2008 19:44:47 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Bob <pongo_bob@yahoo.co.uk>
In-Reply-To: <340713.40525.qm@web27704.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <340713.40525.qm@web27704.mail.ukl.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge Nova-TD-500 84xxx remote control
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

On Fri, Dec 19, 2008 at 7:35 PM, Bob <pongo_bob@yahoo.co.uk> wrote:
> Hi,
>
> I don't know much about hg diffs. Might be better if you do the tweaks. I've now got my TD-500 working with MythTV and lirc and I'm a happy bunny. How long does it take for v4l changes to appear in the stable kernel code ?
>
> regards,

Hello Bob,

Assuming you followed the instructions on http://linuxtv.org/repo to
install the latest source, just do the following

cd v4l-dvb
hg diff > tda_500_remote.diff

And then send me the "tda_500_remote.diff" file.

In terms of "how long it takes to appear in the stable kernel code",
there are typically three levels - first the change will appear in the
http://linuxtv.org/hg/v4l-dvb repository, and then when the next merge
window opens it gets pushed to the mainline kernel for inclusion in
the next release.  Then the Linux distributions take in that kernel
for their next major release.

So, for a relatively straightforward change like this it will usually
take three to six months (depending on the distribution's release
cycle).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
