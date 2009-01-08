Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+6fe81ee853252f17f9b7+1964+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1LKv15-0000H1-G6
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 14:33:43 +0100
Date: Thu, 8 Jan 2009 11:33:33 -0200 (BRST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
In-Reply-To: <4965EC59.60001@cadsoft.de>
Message-ID: <alpine.LRH.2.00.0901081125500.12040@pedra.chehab.org>
References: <20090107000932.68355506@pedra.chehab.org>
	<4965EC59.60001@cadsoft.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] [ANNOUNCE] V4L,
 DVB and Maintainers Mailing Lists at vger.kernel.org
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

On Thu, 8 Jan 2009, Klaus Schmidinger wrote:

> On 07.01.2009 03:09, Mauro Carvalho Chehab wrote:
>> V4L, DVB and V4L/DVB Maintainers Mailing Lists Were merged on Jan, 2 2009 at vger.kernel.org
>>
>> The idea of merging the mailing lists is running around for some time.
>>
>> It took some time for me to have time to address this issue, but it finally happened. We've just created it as:
>>
>>     * linux-media@vger.kernel.org
>> ...
>
> I just subscribed to this list and already received a first posting.
> Unfortunately this list doesn't mark postings' subjects with the
> list name, as in
>
>  [linux-dvb] Merging V4L, DVB and Maintainers Mailing lists...
>
> where I could immediately see whether this is a "normal" email
> or a list posting.
>
> Could this please be changed, so that there is a [listname] prefix?

Probably this could be changed, but this would have some other impacts, 
like adding the list name on the submitted patches. Also, The list were 
created using the same config as all the other Linux kernel development 
lists. The previous experiences shows that having a different model on our 
development means more work and more troubles that could otherwise be 
avoided (for example, using -hg instea of -git ended to be a large source 
of troubles for maintaining it).

What I do here is to create a filtering rule to split mailing list patches 
on a separate INBOX, based on this message header:

 	X-Mailing-List: linux-media@vger.kernel.org

If your emailer is powerful enough, maybe you can also prefix something at 
the subject when this header is seen. For example, on claws-mail, you can 
color the message based on a filtering rule.

Cheers,
Mauro.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
