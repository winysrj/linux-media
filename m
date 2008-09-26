Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gordons.ginandtonic.no ([195.159.29.69])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anders@ginandtonic.no>) id 1Kj807-0006Ci-UR
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 09:44:33 +0200
Message-ID: <48DC92B8.5090406@ginandtonic.no>
Date: Fri, 26 Sep 2008 09:43:52 +0200
From: Anders Semb Hermansen <anders@ginandtonic.no>
MIME-Version: 1.0
To: Darron Broad <darron@kewl.org>
References: <953A45C4-975B-4A05-8B41-AE8A486D0CA6@ginandtonic.no>
	<5584.1222273099@kewl.org>
	<F70AC72F-8DF3-4A9A-BFA1-A4FED9D3EABC@ginandtonic.no>
	<6380.1222276810@kewl.org>
	<8C08530B-BAD7-4E83-B1CA-6AB66EE9F53F@ginandtonic.no>
	<48DA94F7.1090005@linuxtv.org> <23840.1222386126@kewl.org>
In-Reply-To: <23840.1222386126@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-4000 and analogue tv
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

Darron Broad wrote:
> Two issues have been found with what's been highlighted here.
> 
> One has been discovered in cx88-video and another in mythtv.
> 
> You will be happy to know that both are fixed.
> 
> You can find the mythtv fix here:
> 	http://dev.kewl.org/v4l-dvb/TVRec_TuningNewRecorder_mythtv-0.21-fixes-18432.diff
> 
> The cx88-video fix is also available in the same directory:
> 	http://dev.kewl.org/v4l-dvb/v4l-dvb-cx88-atomic-9029.diff
> 
> From what I can see, only the former is necessary in your case but
> you can apply the latter if you wish.

Thanks Darron. I'll guess I wait and see what happens with:
http://svn.mythtv.org/trac/ticket/5744

With working analogue I can look forward to November 11th when DVB-T 
broadcast begins in my area in Norway.


Thanks again,
Anders

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
