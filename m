Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Mon, 1 Sep 2008 12:06:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20080901120601.044ddc30@mchehab.chehab.org>
In-Reply-To: <48B9360D.7030303@gmail.com>
References: <48B9360D.7030303@gmail.com>
Mime-Version: 1.0
Cc: v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [linux-dvb] Merge multiproto tree
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

Hello, Manu,

On Sat, 30 Aug 2008, Manu Abraham wrote:

>  Hello Mauro,
>
>  Please pull from http://jusst.de/hg/multiproto_api_merge/
>  to merge the following Changesets from the multiproto tree.

The need for supporting newer DTV protocols increases day by day, since when
the first multiproto proposal started to be discussed, about two years ago.

At the end of the last year, Steven send one email to the ML with a different 
API proposal. Yet, people decided to wait for your work to be done. People then 
pinged you, from time to time, asking about the completion of multiproto. All 
the times, your answer were that multiproto were not ready yet for production.

I'm aware that your solution seems to be more code-complete than Steven's 
proposal.

But the recent activity on the mailing list regarding his idea (and its, 
so far, positive feedback) and the fact that I was anyway planning to 
have a discussion about the future of the DVB-API at the Linux Plumbers 
Conference 2008 are supporting me in my idea of post-poning such a pull to 
a point in time shortly after this event.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
