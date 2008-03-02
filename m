Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <trygve.iversland@gmail.com>) id 1JVw4p-0004cC-03
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 22:50:35 +0100
Received: by wf-out-1314.google.com with SMTP id 28so5669598wfa.17
	for <linux-dvb@linuxtv.org>; Sun, 02 Mar 2008 13:50:29 -0800 (PST)
Message-ID: <b78112c20803021350t530f1e20x84cc97c3728492ae@mail.gmail.com>
Date: Sun, 2 Mar 2008 22:50:28 +0100
From: "Trygve Iversland" <trygve.iversland@gmail.com>
To: "Geir Inge" <geir.inge@gmail.com>
In-Reply-To: <ab58b93b0803021145j34f4ad49s980e4a30a97d20de@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <ab58b93b0803021145j34f4ad49s980e4a30a97d20de@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] scan fails to detect pid's for streams
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

[...]
>  As you can see it tunes to pid 0 for both audio and video
>
>  Here is the channel data from the channel.conf file:
>
>  NRK2:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:102
>
Seems that you are trying to tune to norwegian H.264/AAC channels,
which aren't supported by scan. A patch is described at
http://www.mythtv.co.nz/mythtv/
Running scan with -vv will give you a quick idea of which pid's to
use. You should probably end up with something like this:

NRK2:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:525:692:102


Trygve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
