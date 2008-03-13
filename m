Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from difo.com ([217.147.177.146] helo=thin.difo.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ivor@ivor.org>) id 1JZlsP-0005AT-6q
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 12:45:58 +0100
Date: Thu, 13 Mar 2008 11:39:25 +0000
From: Ivor Hewitt <ivor@ivor.org>
To: Patrik Hansson <patrik@wintergatan.com>
Message-ID: <20080313113925.GA31869@mythbackend.home.ivor.org>
References: <20080311110707.GA15085@mythbackend.home.ivor.org>
	<1205234401.7463.10.camel@acropora>
	<8ad9209c0803110855w2d469ab9x1e4e4f5a70799d80@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8ad9209c0803110855w2d469ab9x1e4e4f5a70799d80@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

On Tue, Mar 11, 2008 at 04:55:24PM +0100, Patrik Hansson wrote:
> Have you applied any patches to the v4l-dvb source before compiling ?
> 
No patches applied to v4ldvb or kernel source.

> On 3/11/08, Nicolas Will <nico@youplala.net> wrote:
>> What changed between 2.6.22 and 2.6.24? huh... funny, heh?
>>
>> So, if 2.6.24 is finger pointed, I'm interested in a solution, as I have
>> a planned upgrade to it in about a month's time.
>>
In fact I saw failures against linux-2.6.23.12 I've diffed the two trees and am browsing (at leisure) the changes to see if anything "leaps out".

Just enabled mythtv multirec too to see if I can put a bit more stress on the system, still no failures. When I have time I'll flip back to 2.6.11.19 and see how easy/quickly I can get it to fail again.

Cheers,
Ivor.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
