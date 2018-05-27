Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49335 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755127AbeE0LYO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 May 2018 07:24:14 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Matthias Reichl <hias@horus.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Y Song <ys114321@gmail.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH v5 1/3] bpf: bpf_prog_array_copy() should return -ENOENT if exclude_prog not found
Date: Sun, 27 May 2018 12:24:08 +0100
Message-Id: <d44044258b35a965d71db5e8ee26289d0fc75ec2.1527419762.git.sean@mess.org>
In-Reply-To: <cover.1527419762.git.sean@mess.org>
References: <cover.1527419762.git.sean@mess.org>
In-Reply-To: <cover.1527419762.git.sean@mess.org>
References: <cover.1527419762.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes is it possible for bpf prog detach to return -ENOENT.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 kernel/bpf/core.c        | 11 +++++++++--
 kernel/trace/bpf_trace.c |  2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index b574dddc05b8..527587de8a67 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1616,6 +1616,7 @@ int bpf_prog_array_copy(struct bpf_prog_array __rcu *old_array,
 	int new_prog_cnt, carry_prog_cnt = 0;
 	struct bpf_prog **existing_prog;
 	struct bpf_prog_array *array;
+	bool found_exclude = false;
 	int new_prog_idx = 0;
 
 	/* Figure out how many existing progs we need to carry over to
@@ -1624,14 +1625,20 @@ int bpf_prog_array_copy(struct bpf_prog_array __rcu *old_array,
 	if (old_array) {
 		existing_prog = old_array->progs;
 		for (; *existing_prog; existing_prog++) {
-			if (*existing_prog != exclude_prog &&
-			    *existing_prog != &dummy_bpf_prog.prog)
+			if (*existing_prog == exclude_prog) {
+				found_exclude = true;
+				continue;
+			}
+			if (*existing_prog != &dummy_bpf_prog.prog)
 				carry_prog_cnt++;
 			if (*existing_prog == include_prog)
 				return -EEXIST;
 		}
 	}
 
+	if (exclude_prog && !found_exclude)
+		return -ENOENT;
+
 	/* How many progs (not NULL) will be in the new array? */
 	new_prog_cnt = carry_prog_cnt;
 	if (include_prog)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 81fdf2fc94ac..af1486d9a0ed 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1006,6 +1006,8 @@ void perf_event_detach_bpf_prog(struct perf_event *event)
 
 	old_array = event->tp_event->prog_array;
 	ret = bpf_prog_array_copy(old_array, event->prog, NULL, &new_array);
+	if (ret == -ENOENT)
+		goto unlock;
 	if (ret < 0) {
 		bpf_prog_array_delete_safe(old_array, event->prog);
 	} else {
-- 
2.17.0
