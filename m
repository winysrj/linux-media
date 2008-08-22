Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [194.250.18.140] (helo=tv-numeric.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1KWRjV-0003j2-6K
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 10:10:58 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: "'Josef Wolf'" <jw@raven.inka.de>,
	<linux-dvb@linuxtv.org>
Date: Fri, 22 Aug 2008 10:10:09 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAOaJZETzR8EqzWu9A9o/UpwEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <20080821211437.GE32022@raven.wolf.lan>
Subject: [linux-dvb] RE :  How to convert MPEG-TS to MPEG-PS on the fly?
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

On Thu, Aug 21, 2008 at 09:17:58PM +0200, Josef Wolf wrote:

>The more I look at this PES stream the more confused I get:  The
>stream_id 0xe0 seems to transport PTS and DTS _only_.  Everything
>else seems to be contained in PES packets with those unknown
>stream_id's.  Here is what I see:

As mentioned in my previous post, the "stream ids" below B9
are ISO 13818-2 "start codes".

Let me try to clarify. A PES header starts with 00 00 01 xx
where xx is in the range B9-FF. A PES payload is a list of
elements. Each element starts with 00 00 01 xx where xx is
in the range 00-B8. The pattern 00 00 01 is never found
anywhere else in an MPEG-2 video stream.

When you analyze a TS, PES headers are "naturally" located
since they start at the beginning of a TS payload with TS
header containing a "payload start unit indicator".

After demuxing PES packets, you get a suite of elements.
Each element starts with 00 00 01 xx. When xx is in the range
B9-FF, this is the start of a PES packet, following the PES
header syntax as specified in ISO 13818-1 and potentially 
containing PTS and DTS. When xx is in the range 00-B8, this
is NOT the start of a PES header, but the start of a video
element inside the payload of the current PES packet. The
syntax of the following bytes depends on the start code xx
and is defined by ISO 13818-2, not -1.

Does this help?
-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
