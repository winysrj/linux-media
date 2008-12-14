Return-path: <video4linux-list-bounces@redhat.com>
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Sun, 14 Dec 2008 20:18:52 +0100
References: <200812121401.55277.laurent.pinchart@skynet.be>
	<200812121425.01922.hverkuil@xs4all.nl>
	<1229104280.3176.18.camel@palomino.walls.org>
In-Reply-To: <1229104280.3176.18.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812142018.52994.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Schimek <mschimek@gmx.at>
Subject: Re: [PATCH v2 3/4] v4l2: Add missing control names
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

Hi Andy,

On Friday 12 December 2008, Andy Walls wrote:
> On Fri, 2008-12-12 at 14:25 +0100, Hans Verkuil wrote:
> > Hi Laurent,
> >
> > Just one tiny suggestion:
> >
> > On Friday 12 December 2008 14:10:36 Laurent Pinchart wrote:
> > > +	/* CAMERA controls */
> > > +	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
> > > +	case V4L2_CID_EXPOSURE_AUTO:		return "Auto-Exposure";
> >
> > I would suggest "Auto Exposure" (no dash). It seems to be the most
> > common way to write it. At least to my eyes the dash looks strange.
> > Perhaps some native English speakers can help out here?
>
> You actually need a professional English teacher, professor, editor, or
> writer for that answer.  The hyphen has, to me, rather confusing rules.
>
> IANAET, but....
>
> For example when modifying a noun you, would likely hyphenate
> adjective-noun modifiers:
>
> "Auto-exposure setting"
>
> But in simple adjective-noun pairs, you would not, as adjectives are
> understood to modify nouns:
>
> "Auto exposure"
>
>
> Also, new compound words in English often get hyphenated when
> introduced, but the hyphen disappears when the word comes into common
> usage: e-mail vs. email.  But even if this were the path "auto-exposure"
> took initially in English, I, as a native English speaker, would likely
> never write "autoexposure".  "o" and "e" as directly adjacent syllabic
> vowels in a written word just seems "wrong".

Thanks for the answer. I'll then go for "Auto Exposure".

Regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
