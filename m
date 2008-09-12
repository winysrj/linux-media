Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n63.bullet.mail.sp1.yahoo.com ([98.136.44.33])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1Ke3ae-00055X-Q5
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 10:01:18 +0200
Date: Fri, 12 Sep 2008 01:00:41 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb <linux-dvb@linuxtv.org>, Steven Toth <stoth@hauppauge.com>,
	Steven Toth <stoth@linuxtv.org>
In-Reply-To: <48CA0355.6080903@linuxtv.org>
MIME-Version: 1.0
Message-ID: <263027.23563.qm@web46116.mail.sp1.yahoo.com>
Cc: mkrufky@linuxtv.org
Subject: [linux-dvb] Siano ISDB [was: Re:  S2API - Status - Thu Sep 11th]
Reply-To: free_beer_for_all@yahoo.com
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

--- On Fri, 9/12/08, Steven Toth <stoth@linuxtv.org> wrote:

> mkrufky spent some time adding S2API isdb-t support to the siano driver, 
> that's working pretty well - tuning via the S2API app.
> 
> http://linuxtv.org/hg/~mkrufky/sms1xxx-isdbt-as-dvbt/

Just a first quick feedback, the following will need to be
frobbed appropriately:

    204         if (id < DEVICE_MODE_DVBT || id > DEVICE_MODE_DVBT_BDA) {
    205                 sms_err("invalid firmware id specified %d", id);
    206                 return -EINVAL;

In order to enable ISDB modes, one will need to specify
module parameter `default_mode=5' or =6, whichever, and,
hmmm, looks like I gotta hunt down a firmware too.

Is one or the other mode, that is, BDA driver or not, to
be preferred?

Obviously I can't receive anything.

Other comments may appear in personal mail to mkrufky, unless
I should keep them here, I think...


thanks,
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
