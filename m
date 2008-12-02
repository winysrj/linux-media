Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail129.messagelabs.com ([216.82.250.147])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <aturbide@rogers.com>) id 1L7aaL-0000kO-2i
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 20:07:02 +0100
Received: from cr344472a (unknown [172.28.23.212])
	by imap1.toshiba.ca (Postfix) with SMTP id 8F8583FC8B
	for <linux-dvb@linuxtv.org>; Tue,  2 Dec 2008 13:58:01 -0500 (EST)
Message-ID: <007801c954b1$29b4d030$0000fea9@cr344472a>
From: "Alain Turbide" <aturbide@rogers.com>
To: <linux-dvb@linuxtv.org>
References: <99503.50867.qm@web88302.mail.re4.yahoo.com>
	<003301c953fc$84e23110$0000fea9@cr344472a>
	<a3ef07920812020937jb0feff7q695f91dbd2156b5e@mail.gmail.com>
Date: Tue, 2 Dec 2008 14:05:44 -0500
MIME-Version: 1.0
Subject: Re: [linux-dvb] [FIXEd] Bug Report - Twinhan vp-1020,
	bt_8xx driver + frontend
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

Well, it's not a difficult fix now that I see it.  The issue was that the 
original default for FE_ALGO_SW was 0 while FE_ALGO_HW was 1.
Since there is an older documented option for the dst module called dst_algo 
that some people might still be using to force the tuning algo to sofware by 
setting dst_algo=0, there is no choice but to also make the default of 
DVBFE_ALGO_SW to also be 0 so that the values will match and the new code 
will still function with users who force dst_algo=0 on the dst module load..
The fix would thus be to go from: this in dvb_frontend.h
enum dvbfe_algo {
        DVBFE_ALGO_HW                   = (1 <<  0),
        DVBFE_ALGO_SW                   = (1 << 1),
        DVBFE_ALGO_CUSTOM               = (1 <<  2),
        DVBFE_ALGO_RECOVERY             = (1 << 31)
};

to this:
enum dvbfe_algo {
        DVBFE_ALGO_HW                   = (1 <<  0),
        DVBFE_ALGO_SW                   = 0,
        DVBFE_ALGO_CUSTOM               = (1 <<  2),
        DVBFE_ALGO_RECOVERY             = (1 << 31)
};

This is what I've done now and works well. This is the only change required 
to fix the issue.   In dst.c we could also default dst_algo to 
DVB_FRONTEND_SW instead of 0 to make it more robust.  I can't see any code 
else where that depends on DVBFE_ALGO_SW being set to 2.

For those that do not want to patch code, the alternate way to get the cards 
to work is to simply load the dst module with the dst_algo parm set. to 2:
ie. modprobe dst dst_algo=2   ( to have the dst module return the current 
value of DVBFE_ALGO_SW) back to the front end code.





----- Original Message ----- 
From: "VDR User" <user.vdr@gmail.com>
To: "Alain Turbide" <aturbide@rogers.com>
Cc: <linux-dvb@linuxtv.org>
Sent: Tuesday, December 02, 2008 12:37 PM
Subject: Re: [linux-dvb] [FIXEd] Bug Report - Twinhan vp-1020, bt_8xx driver 
+ frontend


> 2008/12/1 Alain Turbide <aturbide@rogers.com>:
>> Digging in a little further.The dst_algo (which the twinhan uses) is set 
>> to
>> return  0 as the default setting for the SW algo in dst.c, yet in
>> dvb_frontend.h, the DVBFE_ALGO_SW algo is defined as 2.  Which is the
>> correct one here? Should dst.c be changed to return 2 as sw or is 0 the
>> correct number for the SW algo and thus DVBFE_ALGO_SW be changed to 
>> return
>> 0?
>
> Is nobody else looking into this?!  I would think this bug would have
> received a little more attention considering the number of people
> affected!
>
> Please keep up the work, it's much appreciated!  I, on behalf of
> several others who aren't subscribed to the ml, am monitoring this
> thread in hopes of a proper fix.
>
> Thanks!
> -Derek 


______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
