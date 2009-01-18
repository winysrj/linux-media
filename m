Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <49737088.7060800@rogers.com>
Date: Sun, 18 Jan 2009 13:10:16 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	<496FE555.7090405@rogers.com> <496FFCE2.8010902@rogers.com>
	<200901171720.03890.hverkuil@xs4all.nl>
In-Reply-To: <200901171720.03890.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>, Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Friday 16 January 2009 04:20:02 CityK wrote:
>   
>> The "hack-fix" patch applies cleanly against Hans' sources. However,
>> the test results are negative -- the previous workaround ("modprobe
>> tuner -r and "modprobe tuner") fails to produce the desired result.
>>     
>
> If you try to run 'modprobe -r tuner' when the saa7134 module build from 
> my sources is loaded, then that should not work since saa7134 increases 
> the use-count of the tuner module preventing it from being unloaded.
>
> If you can do this, then that suggests that you are perhaps not using my 
> modified driver at all.
>   

Huh?  Of course I'm using your modified driver.  As a recap:
*  I tried Hans' modified sources and the test result was negative.  I
also attempted (in a similar fashion as to the steps required when using
Mike's "hack/workaround") unloading all the modules and then modprobing
them .... as Mike later explained, the modifications Hans had made are
not enough to correct the issue
* Mike then asked whether:
(a) his "hack/workaround" still applied cleanly against Hans' source,
and stated that, if that was not the case, then he would re-spin the
"hack" patch ... I confirmed that Mike's "hack/workaround" did indeed
apply cleanly against Han's source. 
(b) I was successful in getting the analogue TV working after applying
his "hack/workaround" patch against Hans' source.  However, as I
reported, the results of this test were negative ... as Mauro later
explained, the "hack/workaround" that Mike had spun will no longer work
given the inherent changes introduced in Hans' code

As requested by Mauro, I will provide the dmesg output,  both that from
the base case and then that given when 12c_scan is employed ... but that
will have to occur either later today or sometime during the week ... at
present, I have switched back to an older changeset, as I required
having a functional second TV this weekend

> BTW, I've asked Mauro to pull from my tree 
> (www.linuxtv.org/hg/~hverkuil/v4l-dvb) which contains the converted 
> saa7134 and saa6752hs drivers. It's definitely something that needs to 
> be done regardless.
>   

Err, while I agree that the changes are something that need to be done
(I don't think anyone is in disagreement with that consensus), I don't
think that this is a case of "regardless".    In fact, I stand behind
Mike's position:

> Anyway, if the previous workaround works after Hans' changes, then I
> think his changes should be merged  

But as I have demonstrated above, and as Mauro explained, the previous
"hack/workaround" no longer works in the case of with the Hans source
code.  The "if" case fails!  Consequently, the "else" case should be
don't merge.  Why?  Because we have now gone from:
* circa pre-2.6.25, Mauro's changes that  broke the boards analog TV
support, but which could somewhat be corrected by Mike's "hack/workaround"
* to present, where merging Hans' code eliminates the usability of
Mike's "hack/workaround" ... in essence, analog TV function has now been
completely killed with these boards.

Now, if it is a case that a resolution to the problem is imminently
forthcoming, then I don't think that the merge would be much of a
problem.  However, given the breadth of the conversation so far (and I
really do appreciate the depth of Trent's and Jean's
discussion/consideration on the matter), it is entirely unclear to me
that such a resolution will be found in short order  (although, I don't
discount the possibility of it either).

And, although I may have altered some of the original text at some point
in time (and looking at it now, I see that it could stand for some even
more clean up/revision), I turn everyone's attention to the
http://www.linuxtv.org/wiki/index.php/Development:_Hints_for_Refactoring_Existing_Drivers#Please_do_never_ever_apply_big_Changes_in-place
In particular, the key passage:

> If you plan to rewrite bigger portions of the code please don't create
> a huge patch or thousands of patches but *fork the relevant code
> modules so that people can easily test them concurrently with the old
> code and are free to use the old, usually well-tested code until your
> new version has matured*.
>
> *There have been several situations in the past where the linux-dvb
> CVS was barely usable for weeks or months because we did not followed
> this principle. Please respect that other people are using the
> linux-dvb source in productive environments and rely on a working code
> base. *

If your mail reader supports the html bolding, you will see my
emphasis.  I'm wagging my finger at some of you (ahem, Mauro, to start
with).  Naughty, naughty.   :D






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
