Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n56.bullet.mail.sp1.yahoo.com ([98.136.44.52])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KW9f6-0004eD-Am
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 14:53:14 +0200
Date: Thu, 21 Aug 2008 05:45:56 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org, Beth <beth.null@gmail.com>
In-Reply-To: <7641eb8f0808190718j272d3f49gabe4f33f00154668@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <510456.12261.qm@web46104.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
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

--- On Tue, 8/19/08, Beth <beth.null@gmail.com> wrote:

> don't know what I am looking for, so yes, I get pid
> lists on the
> stream, data from an VID, but I really don't know what
> I am doing, or

Do you have `tspids' available?  You should try
$ tspids < test_100M.ts

and see what numerical PIDs are listed.  Or use a smaller
file (not the full ten hours).  I see you have PID 0, and at
least one other.

Also, the exact name of the station you're trying to tune to
would be helpful, to see if the data you've captured matches
the expected PIDs.  Even the particular line from your tuning
file would be useful to verify it's correct.


barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
