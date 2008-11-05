Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KxlRm-0004uY-2G
	for linux-dvb@linuxtv.org; Wed, 05 Nov 2008 17:41:35 +0100
Received: by el-out-1112.google.com with SMTP id p32so59596elf.14
	for <linux-dvb@linuxtv.org>; Wed, 05 Nov 2008 08:41:29 -0800 (PST)
Message-ID: <37219a840811050841g22108414g2db73b65ed759e75@mail.gmail.com>
Date: Wed, 5 Nov 2008 11:41:27 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Paul Guzowski" <guzowskip@linuxmail.org>
In-Reply-To: <20081105115844.626E8CBBCF@ws5-11.us4.outblaze.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081105115844.626E8CBBCF@ws5-11.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Channel configuration files....
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

On Wed, Nov 5, 2008 at 6:58 AM, Paul Guzowski <guzowskip@linuxmail.org> wrote:
> Greetings,
>
> Does anyone on this list have a sample channel.conf file for Brighthouse Networks cable or can anyone give enough information (frequencies, transponders, etc) so that I can try to build one?  Thanks in advance.
>
> Paul in NW Florida

Paul,

You can use "scan" from dvb-apps, using the scan file,
"us-Cable-Standard-center-frequencies-QAM256" ...  If that doesn't
work, you can try the other QAM256 cable scan files, located in the
util/scan/atsc/ directory of dvb-apps.

Alternatively, you can use the latest version of w_scan WITHOUT any
scan file.  This should produce the best results.

The latest version of w_scan with atsc / qam scanning support can be
downloaded from here:

http://wirbel.htpc-forum.de/w_scan/w_scan-20080815.tar.bz2

You can scan cable using this command:

w_scan -A2 -X > channels.conf

Good luck.

-Mike Krufky

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
