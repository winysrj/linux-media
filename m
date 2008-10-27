Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9R2N86a010815
	for <video4linux-list@redhat.com>; Sun, 26 Oct 2008 22:23:08 -0400
Received: from smtp104.rog.mail.re2.yahoo.com (smtp104.rog.mail.re2.yahoo.com
	[206.190.36.82])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9R2MYWW024379
	for <video4linux-list@redhat.com>; Sun, 26 Oct 2008 22:22:34 -0400
Message-ID: <490525EA.4020608@rogers.com>
Date: Sun, 26 Oct 2008 22:22:34 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Announcement: wiki merger and some loose ends
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi folks,

Three items of interest:

1) I've started the merger of the V4L and DVB wikis.  I posted an
announcement on the main page of both.

Offhand, I can't remember what the exact licensing issue was (no longer
have emails and couldn't find the post discussing this on the m/l's in a
cursory search), so that part of the announcement I posted is a little
lacking in description.  Hopefully someone else can recall or fill in
the details of the legal mumbo-jumbo.  Personally, the issue is moot to
me.  And lastly, I'm going to pre-emptively state that I'm not at all
interested in any sort of dialogue with those who might be so inclined
to try to turn this issue into an episode of political bureaucratic
zealotry. 

If anyone else can improve upon the announcement, or think of other
things that might be important to address, then by all means please do so.

Issues I've run into so far are:
- I couldn't create a new namespace in the Linuxtv wiki ... seems to me,
IIRC, that I successfully tested doing this previously, so I'm not sure
why it didn't work today
- images don't export/import properly ... going to have to figure
something out about that one
- unlike articles in the "main" namespace of the wikis, there doesn't
seem to be a way to rename images ... need some sort of file management
feature, as a number of the images are poorly named.


2) In a related issue regarding the wiki(s), and one for which I have
reached inquiries before, I will post Devin's questions to me and try to
provide an answer:

Devin Heitmueller wrote:
> Hello there,
>
> Thanks for posting to the list so I could reach out to you.
>
> I wanted to ask you about some deletes you performed on the linux-dvb
> wiki, with the only comment being "redundant":
>
> # 23:09, 24 August 2008 CityK (Talk | contribs) deleted "Hvr 950" ‎ (redundant)
> # 23:09, 24 August 2008 CityK (Talk | contribs) deleted "Hvr950" ‎ (redundant)
> # 23:08, 24 August 2008 CityK (Talk | contribs) deleted "Hvr-950" ‎ (redundant)
>
> These were actually intentionally created as redirect pages so that
> searches would properly send user to the correct page.  Both "hvr" and
> "950" are too short for the mediawiki indexing engine.  This is a
> common practice in mediawiki.
>
> In fact, without these redirects I couldn't find *anything* I could
> put into the search box that would result in pointing the user to the
> HVR-950 page.  The only way to get there was to go through the various
> pages ATSC->ATSC USB Devices.
>
> If you have a suggestion as to how else to deal with this issue
> related to search, I am more willing to listen.
>
> Regards,
>
> Devin
>
>   
Hi Devin,

First off, thanks for all the work you have done in the wiki, as it
doesn't go unnoticed.  To address your email:

I certainly understand that those pages were intentionally created.  
The general reasoning for my removing them can be found on my user page
(http://www.linuxtv.org/wiki/index.php/User:CityK) under the "here's
what I propose" and "User Sign up /Login Subpage" sections. 
Specifically: :

"Formalize entries 

    * this includes proper article naming .... more then slightly
      pedantic, but necessary (think libraries -- they don't just throw
      things on shelves)"

and

"As the wiki grows, it takes an increasing amount of effort and
discipline to keep it from quickly turning into a tangled mess. So it's
up to each of us to make sure the information submitted is easy for
everybody to find and access.

If you make a contribution and later find that your submission has been
edited or moved to another area of the wiki, please don't feel offended.
Everyone understands and appreciates the time and efforts you took, but
bear in mind that a factual and well-organized resource for everyone
interested in analog or digital TV is the ultimate aim of the LinuxTV wiki."

I note that "hvr950" itself definitely produces a hit result in the
search, but the other two do indeed suffer as a result of the three
letter search limitation (both a space and dash are not read by the
search engine).    However, there isn't anything unique to the hvr-950
in this regards, as the same thing holds true with plenty of other
entries (e.g. perform a search in the wiki(s) for , say, "QAM", "NXP",
"MSI", "i2c", "VLC" , "RDS" etc etc etc.). The three letter search
limitation is quite common to most forums and wikis.  I have no idea if
there is much that we can do about that. 

But I do know that multiple redirects makes things messy and lends
itself to complications.  (Nor is it necessary to have every possible
spelling of entries, as some have done -- hypothetical example for the
word digital: digital, Digital, DIGITAL, dig., Dig. etc ).

I also would encourage people to use the indexes (link provided on main
pages of wiki(s)) when searching.  They are neat and orderly, and if you
are viewing the page with a browser that supports "find as you type",
finding "950" takes seconds.

I also specifically implemented a triangular gateway system between
manufacturer pages,  device type and the actual device page.  So, it
usually shouldn't be too hard to find a particular model if its been
added to the wiki [I note that, since formalizing entries (e.g.
Hauppauge WinTV-HVR-950, as opposed to simply "hvr-950"), other users
have caught on to the nomenclature system, as well as adopting the
similar article section layout!  It used to be quite common that someone
would just simply create, say, "TV Walker" as opposed to a formal
"LifeView TV Walker Twin DVB-T (LR540)" entry].

In conclusion, I would like to see redirects kept to a bear minimum and
believe that finding device information in the wiki(s) is not that
difficult, and is aided by several vectors/avenues of approach by which
the user can take.


3) For your viewing pleasure (and in the spirit of Halloween) I 
resurrect an older thread that I'd like to see some meaning movement
made upon :

http://marc.info/?l=linux-dvb&m=120000803816050&w=2










--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
