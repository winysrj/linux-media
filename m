Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:56216 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaC3GKo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 02:10:44 -0400
MIME-Version: 1.0
In-Reply-To: <533553E6.3060508@xs4all.nl>
References: <532442E2.7050206@xs4all.nl>
	<532443AB.9080105@xs4all.nl>
	<533553E6.3060508@xs4all.nl>
Date: Sat, 29 Mar 2014 23:10:43 -0700
Message-ID: <CANeU7Qksj-tq0fjsZya1otX75sV4JOsAdXHr5Kxu-WyvYrksSw@mail.gmail.com>
Subject: Re: sparse: ARRAY_SIZE and sparse array initialization
From: Christopher Li <sparse@chrisli.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux-Sparse <linux-sparse@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 28, 2014 at 3:50 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Is there any chance that the three issues I reported will be fixed? If not,
> then I'll work around it in the kernel code.
>

Most likely it is a sparse issue. Can you generate a minimal stand alone
test case that expose this bug? I try to simplify it as following, but
it does not
reproduce the error.


#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

static const char *v4l2_type_names[] = {
        [1]    = "mmap",
        [9] = "userptr",
        [2] = "overlay",
        [3] = "dmabuf",
};

#define prt_names(a, arr) (((unsigned)(a)) < ARRAY_SIZE(arr) ? arr[a]
: "unknown")


extern void prt(const char *name);

static void v4l_print_requestbuffers(const void *arg, int write_only)
{
        const struct v4l2_requestbuffers *p = arg;

        prt(prt_names(3, v4l2_type_names));
}


If you have the test case, you are welcome to submit a patch to
add the test case.

Chris
